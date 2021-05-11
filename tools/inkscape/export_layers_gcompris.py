#! /usr/bin/env python

#
# GCompris - export_layers_gcompris.py
#
# SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later
#
# An Inkscape extension to export svg maps with center coordinates in a text file,
# to generate content for puzzle/maps activities
# based on https://github.com/dja001/inkscape-export-layers

import collections
import contextlib
import copy
import os
import shutil
import subprocess
import sys
import tempfile

sys.path.append('/usr/share/inkscape/extensions')
import inkex

Layer = collections.namedtuple('Layer', ['id', 'label', 'tag'])
Export = collections.namedtuple('Export', ['visible_layers', 'file_name'])

FIXED  = '[fixed]'
F      = '[f]'
EXPORT = ''
E      = '[e]'
BACK   = '[back]'

SVG = 'svg'
PNG = 'png'

DOCWIDTH = 0
DOCHEIGHT = 0
DOCNAME = ''

coordinates_string = ""

class LayerExport(inkex.Effect):
    def __init__(self):
        inkex.Effect.__init__(self)
        self.arg_parser.add_argument('-o', '--output-source',
                                     action='store',
                                     type=str,
                                     dest='output_source',
                                     default='~/',
                                     help='Path to source file in output directory')
        self.arg_parser.add_argument('--output-subdir',
                                     action='store',
                                     type=str,
                                     dest='output_subdir',
                                     default='',
                                     help='name of sub-directory in output path')
        self.arg_parser.add_argument('-f', '--file-type',
                                     action='store',
                                     choices=(SVG, PNG),
                                     dest='file_type',
                                     default='svg',
                                     help='Exported file type')
        self.arg_parser.add_argument('--fit-contents',
                                     action='store',
                                     type=str,
                                     dest='fit_contents',
                                     default=True,
                                     help='Fit output to content bounds')
        self.arg_parser.add_argument('--dpi',
                                     action='store',
                                     type=int,
                                     dest='dpi',
                                     default=None,
                                     help="Export DPI value")
        self.arg_parser.add_argument('--enumerate',
                                     action='store',
                                     type=str,
                                     dest='enumerate',
                                     default=None,
                                     help="suffix of files exported")
        self.arg_parser.add_argument('--show-layers-below',
                                     action='store',
                                     type=str,
                                     dest='show_layers_below',
                                     default=None,
                                     help="Show exported layers below the current layer")

    def effect(self):

        #process bool inputs that were read as strings
        self.options.fit_contents      = True if self.options.fit_contents      == 'true' else False
        self.options.enumerate         = True if self.options.enumerate         == 'true' else False
        self.options.show_layers_below = True if self.options.show_layers_below == 'true' else False

        #get output dir from specified source file
        #otherwise set it as $HOME
        source = self.options.output_source
        if os.path.isfile(source):
            output_dir = os.path.dirname(source)
            prefix = os.path.splitext(os.path.basename(source))[0]+'_'
        elif os.path.isdir(source):
            #change the default filled in by inkscape to $HOME
            if os.path.basename(source) == 'inkscape-export-layers':
                output_dir = os.path.expanduser('~/')
                prefix = ''
            else:
                output_dir = os.path.join(source)
                prefix = ''
        else:
            raise Exception('output_source not a file or a dir...')

        #add subdir if one was passed
        output_dir = os.path.join(output_dir, self.options.output_subdir)

        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        layer_list = self.get_layer_list()
        export_background = self.get_export_background(layer_list, self.options.show_layers_below)
        export_list = self.get_export_list(layer_list, self.options.show_layers_below)

        #get document infos
        global DOCWIDTH
        DOCWIDTH = float(self.svg.get("width"))
        global DOCHEIGHT
        DOCHEIGHT = float(self.svg.get("height"))
        global DOCNAME
        DOCNAME = self.svg.get("sodipodi:docname")

        with _make_temp_directory() as tmp_dir:
            for export in export_background:
                svg_file = self.export_to_svg(export, tmp_dir)
                isNotBackground = False

                if self.options.file_type == PNG:
                    if not self.convert_svg_to_png(svg_file, output_dir, prefix, isNotBackground):
                        break
                elif self.options.file_type == SVG:
                    if not self.convert_svg_to_svg(svg_file, output_dir, prefix, isNotBackground):
                        break

        with _make_temp_directory() as tmp_dir:
            for export in export_list:
                svg_file = self.export_to_svg(export, tmp_dir)
                isNotBackground = True

                if self.options.file_type == PNG:
                    if not self.convert_svg_to_png(svg_file, output_dir, prefix, isNotBackground):
                        break
                elif self.options.file_type == SVG:
                    if not self.convert_svg_to_svg(svg_file, output_dir, prefix, isNotBackground):
                        break

        coords_text_file = os.path.join(output_dir, DOCNAME + '.txt')
        with open(coords_text_file, "w") as text_file:
            print("{}".format(coordinates_string), file=text_file)

    def get_layer_list(self):
        """make a list of layers in source svg file
            Elements of the list are  of the form (id, label (layer name), tag ('[fixed]' or '[back]' or '[export]')
        """
        svg_layers = self.document.xpath('//svg:g[@inkscape:groupmode="layer"]',
                                         namespaces=inkex.NSS)
        layer_list = []

        for layer in svg_layers:
            label_attrib_name = '{%s}label' % layer.nsmap['inkscape']
            if label_attrib_name not in layer.attrib:
                continue

            layer_id = layer.attrib['id']
            layer_label = layer.attrib[label_attrib_name]

            if layer_label.lower().startswith(FIXED):
                layer_type = FIXED
                layer_label = layer_label[len(FIXED):].lstrip()
            elif layer_label.lower().startswith(F):
                layer_type = FIXED
                layer_label = layer_label[len(F):].lstrip()
            elif layer_label.lower().startswith(BACK):
                layer_type = BACK
                layer_label = layer_label[len(BACK):].lstrip()
            elif layer_label.lower().startswith(EXPORT):
                layer_type = EXPORT
                layer_label = layer_label[len(EXPORT):].lstrip()
            else:
                continue

            layer_list.append(Layer(layer_id, layer_label, layer_type))

        return layer_list

    def get_export_list(self, layer_list, show_layers_below):
        """selection of layers that should be visible

            Each element of this list will be exported in its own file
        """
        export_list = []

        for counter, layer in enumerate(layer_list):
            #each layer marked as '[export]' is the basis for making a figure that will be exported

            if layer.tag == FIXED:
                #Fixed layers are not the basis of exported figures
                continue
            elif layer.tag == EXPORT:

                #determine which other layers should appear in this figure
                visible_layers = set()
                layer_is_below = True
                for other_layer in layer_list:
                    if other_layer.tag == FIXED:
                        #fixed layers appear in all figures
                        #irrespective of their position relative to other layers
                        visible_layers.add(other_layer.id)
                    else:
                        if other_layer.id == layer.id:
                            #the basis layer for this figure is always visible
                            visible_layers.add(other_layer.id)
                            #all subsequent layers will be above
                            layer_is_below = False

                        elif layer_is_below and show_layers_below:
                            visible_layers.add(other_layer.id)

                layer_name = layer.label
                if self.options.enumerate:
                    layer_name = '{:03d}_{}'.format(counter + 1, layer_name)

                export_list.append(Export(visible_layers, layer_name))
            else:
                #layers not marked as FIXED of EXPORT are ignored
                pass

        return export_list

    def get_export_background(self, layer_list, show_layers_below):
        """selection of files with [back] tag,
            to always render at document boundaries size
        """
        export_list = []

        for counter, layer in enumerate(layer_list):
            #each layer marked as '[export]' is the basis for making a figure that will be exported

            if layer.tag == FIXED:
                #Fixed layers are not the basis of exported figures
                continue
            elif layer.tag == BACK:

                #determine which other layers should appear in this figure
                visible_layers = set()
                layer_is_below = True
                for other_layer in layer_list:
                    if other_layer.tag == FIXED:
                        #fixed layers appear in all figures
                        #irrespective of their position relative to other layers
                        visible_layers.add(other_layer.id)
                    else:
                        if other_layer.id == layer.id:
                            #the basis layer for this figure is always visible
                            visible_layers.add(other_layer.id)
                            #all subsequent layers will be above
                            layer_is_below = False

                        elif layer_is_below and show_layers_below:
                            visible_layers.add(other_layer.id)

                layer_name = layer.label
                if self.options.enumerate:
                    layer_name = '{:03d}_{}'.format(counter + 1, layer_name)

                export_list.append(Export(visible_layers, layer_name))
            else:
                #layers not marked as FIXED of BACK are ignored
                pass

        return export_list

    def export_to_svg(self, export, output_dir):
        """
        Export a current document to an Inkscape SVG file.
        :arg Export export: Export description.
        :arg str output_dir: Path to an output directory.
        :return Output file path.
        """
        document = copy.deepcopy(self.document)

        svg_layers = document.xpath('//svg:g[@inkscape:groupmode="layer"]',
                                    namespaces=inkex.NSS)

        content_bb = []
        content_x1 = 0
        content_x2 = 0
        content_y1 = 0
        content_y2 = 0

        for layer in svg_layers:
            if layer.attrib['id'] in export.visible_layers:
                layer.attrib['style'] = 'display:inline'
                self.svg.selection = layer.descendants()
                content_bb = self.svg.selection.first().bounding_box()
            else:
                layer.delete()

        #find coords and size of selection
        content_x1 = content_bb.left
        content_x2 = content_bb.right
        content_y1 = content_bb.top
        content_y2 = content_bb.bottom

        content_x_center = (((content_x2 - content_x1) / 2) + content_x1) / DOCWIDTH
        content_y_center = (((content_y2 - content_y1) / 2) + content_y1) / DOCHEIGHT

        content_x_center = round(content_x_center, 4)
        content_y_center= round(content_y_center, 4)

        #example to write coordinates to string...
        global coordinates_string
        coordinates_string += export.file_name
        coordinates_string += ", X: "
        coordinates_string += str(content_x_center)
        coordinates_string += ", Y: "
        coordinates_string += str(content_y_center)
        coordinates_string += "\n"

        output_file = os.path.join(output_dir, export.file_name + '.svg')
        document.write(output_file)

        return output_file

    def convert_svg_to_png(self, svg_file, output_dir, prefix, isNotBackground):
        """
        Convert an SVG file into a PNG file.
        :param str svg_file: Path an input SVG file.
        :param str output_dir: Path to an output directory.
        :return Output file path.
        """
        source_file_name = os.path.splitext(os.path.basename(svg_file))[0]
        output_file = os.path.join(output_dir, prefix+source_file_name + '.png')
        command = [
            'inkscape',
            svg_file.encode('utf-8'),
            '--batch-process',
            '--export-area-drawing' if self.options.fit_contents and isNotBackground else
            '--export-area-page',
            '--export-dpi', str(self.options.dpi),
            '--export-type', 'png',
            '--export-filename', output_file.encode('utf-8'),
        ]
        result = subprocess.run(command, capture_output=True)
        if result.returncode != 0:
            raise Exception('Failed to convert %s to PNG' % svg_file)

        return output_file

    def convert_svg_to_svg(self, svg_file, output_dir, prefix, isNotBackground):
        """
        Convert an [Inkscape] SVG file into a standard (plain) SVG file.
        :param str svg_file: Path an input SVG file.
        :param str output_dir: Path to an output directory.
        :return Output file path.
        """
        source_file_name = os.path.splitext(os.path.basename(svg_file))[0]
        output_file = os.path.join(output_dir, prefix+source_file_name + '.svg')
        command = [
            'inkscape',
            svg_file.encode('utf-8'),
            '--batch-process',
            '--export-area-drawing' if self.options.fit_contents and isNotBackground else
            '--export-area-page',
            '--export-dpi', str(self.options.dpi),
            '--export-plain-svg',
            '--vacuum-defs',
            '--export-filename',output_file.encode('utf-8')
        ]
        result = subprocess.run(command, capture_output=True)
        if result.returncode != 0:
            raise Exception('Failed to convert %s to SVG' % svg_file)

        return output_file


@contextlib.contextmanager
def _make_temp_directory():
    temp_dir = tempfile.mkdtemp(prefix='tmp-inkscape')
    try:
        yield temp_dir
    finally:
        shutil.rmtree(temp_dir)


if __name__ == '__main__':
    try:
        LayerExport().run(output=False)
    except Exception as e:
        inkex.errormsg(str(e))
        sys.exit(1)
