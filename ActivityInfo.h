#ifndef MENU_H
#define MENU_H

#include <qqml.h>


class ActivityInfo : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
	Q_PROPERTY(QString dir READ dir WRITE setDir NOTIFY dirChanged)
	Q_PROPERTY(QString section READ section WRITE setSection NOTIFY sectionChanged)
	Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
	Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)
	Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)
	Q_PROPERTY(QString boarddir READ boarddir WRITE setBoarddir NOTIFY boarddirChanged)
	Q_PROPERTY(bool demo READ demo WRITE setDemo NOTIFY demoChanged)
	Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
	Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
	Q_PROPERTY(QString goal READ goal WRITE setGoal NOTIFY goalChanged)
	Q_PROPERTY(QString prerequisite READ prerequisite WRITE setPrerequisite NOTIFY prerequisiteChanged)
	Q_PROPERTY(QString manual READ manual WRITE setManual NOTIFY manualChanged)
	Q_PROPERTY(QString credit READ credit WRITE setCredit NOTIFY creditChanged)


public:
	ActivityInfo(QObject *parent = 0);

	QString name() const;
	void setName(const QString &);
	QString type() const;
	void setType(const QString &);
	QString dir() const;
	void setDir(const QString &);
	QString section() const;
	void setSection(const QString &);
	int difficulty() const;
	void setDifficulty(const int &);
	QString icon() const;
	void setIcon(const QString &);
	QString author() const;
	void setAuthor(const QString &);
	QString boarddir() const;
	void setBoarddir(const QString &);
	bool demo() const;
	void setDemo(const bool &);
	QString title() const;
	void setTitle(const QString &);
	QString description() const;
	void setDescription(const QString &);
	QString goal() const;
	void setGoal(const QString &);
	QString prerequisite() const;
	void setPrerequisite(const QString &);
	QString manual() const;
	void setManual(const QString &);
	QString credit() const;
	void setCredit(const QString &);

	QStringList getSectionPath();

signals:
	void nameChanged();
	void typeChanged();
	void dirChanged();
	void sectionChanged();
	void difficultyChanged();
	void iconChanged();
	void authorChanged();
	void boarddirChanged();
	void demoChanged();
	void titleChanged();
	void descriptionChanged();
	void goalChanged();
	void prerequisiteChanged();
	void manualChanged();
	void creditChanged();
	
private:
	QString m_name;
	QString m_type;
	QString m_dir;
	QString m_section;
	int m_difficulty;
	QString m_icon;
	QString m_author;
	QString m_boarddir;
	bool m_demo;
	QString m_title;
	QString m_description;
	QString m_goal;
	QString m_prerequisite;
	QString m_manual;
	QString m_credit;


};

#endif // MENU_H
