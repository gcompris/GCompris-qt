#ifndef ENTITYCOLLECTION_H
#define ENTITYCOLLECTION_H

#include <QJsonArray>
#include <QJsonValue>
#include <QObject>

#include <cm-lib_global.h>

namespace cm {
namespace data {

class Entity;

class CMLIBSHARED_EXPORT EntityCollectionObject : public QObject
{
	Q_OBJECT

public:
	EntityCollectionObject(QObject* _parent = nullptr) : QObject(_parent) {}
	virtual ~EntityCollectionObject() {}

signals:
	void collectionChanged();
};

class EntityCollectionBase : public EntityCollectionObject
{
public:
	EntityCollectionBase(QObject* parent = nullptr, const QString& key = "SomeCollectionKey")
		: EntityCollectionObject(parent)
		, key(key)
	{}

	virtual ~EntityCollectionBase()
	{}

	QString getKey() const
	{
		return key;
	}

	virtual void clear() = 0;
	virtual void update(const QJsonArray& json) = 0;
	virtual std::vector<Entity*> baseEntities() = 0;

	template <class T>
	QList<T*>& derivedEntities();

	template <class T>
	T* addEntity(T* entity);

private:
	QString key;
};

template <typename T>
class EntityCollection : public EntityCollectionBase
{
public:
	EntityCollection(QObject* parent = nullptr, const QString& key = "SomeCollectionKey")
		: EntityCollectionBase(parent, key)
	{}

	~EntityCollection()
	{}

	void clear() override
	{
		for(auto entity : collection) {
			entity->deleteLater();
		}
		collection.clear();
	}

	void update(const QJsonArray& jsonArray) override
	{
		clear();
		for(const QJsonValue& jsonValue : jsonArray) {
			addEntity(new T(this, jsonValue.toObject()));
		}
	}

	std::vector<Entity*> baseEntities() override
	{
		std::vector<Entity*> returnValue;
		for(T* entity : collection) {
			returnValue.push_back(entity);
		}
		return returnValue;
	}

	QList<T*>& derivedEntities()
	{
		return collection;
	}

	T* addEntity(T* entity)
	{
		if(!collection.contains(entity)) {
			collection.append(entity);
			EntityCollectionObject::collectionChanged();
		}
		return entity;
	}

private:
	QList<T*> collection;
};

template <class T>
QList<T*>& EntityCollectionBase::derivedEntities()
{
	return dynamic_cast<const EntityCollection<T>&>(*this).derivedEntities();
}

template <class T>
T* EntityCollectionBase::addEntity(T* entity)
{
	return dynamic_cast<const EntityCollection<T>&>(*this).addEntity(entity);
}

}}

#endif
