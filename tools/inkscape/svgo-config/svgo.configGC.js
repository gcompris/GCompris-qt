// config used to optimize SVG files with svgo tool but keeping useful info (author, license ...),
// avoiding desctructive changes and keeping it easy to edit if needed
module.exports = {
  plugins: [
    'removeDoctype',
    'removeXMLProcInst',
    'cleanupAttrs',
    'mergeStyles',
    'inlineStyles',
    'minifyStyles',
    'cleanupIDs',
    'removeUselessDefs',
    'convertColors',
    'removeUnknownsAndDefaults',
    'removeNonInheritableGroupAttrs',
    'removeUselessStrokeAndFill',
    'cleanupEnableBackground',
    'removeHiddenElems',
    'removeEmptyText',
    'moveElemsAttrsToGroup',
    'moveGroupAttrsToElems',
    'collapseGroups',
    'removeEmptyAttrs',
    'removeEmptyContainers',
    'removeUnusedNS',
    'sortDefsChildren',
    'removeDesc'
  ]
}
