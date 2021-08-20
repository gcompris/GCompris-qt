#include "entity.h"

#include <QJsonArray>
#include <QUuid>

namespace cm {
namespace data {

class Entity::Implementation
{
public:
	Implementation(Entity* _entity, const QString& _key)
		: entity(_entity)
		, key(_key)
		, id(QUuid::createUuid().toString())
	{
	}
	Entity* entity{nullptr};
	QString key;
	QString id;
	StringDecorator* primaryKey{nullptr};
	std::map<QString, EntityCollectionBase*> childCollections;
	std::map<QString, Entity*> childEntities;
	std::map<QString, DataDecorator*> dataDecorators;
};

Entity::Entity(QObject* parent, const QString& key)
	: QObject(parent)
{
	implementation.reset(new Implementation(this, key));
}

Entity::Entity(QObject* parent, const QString& key, const QJsonObject& jsonObject)
	: Entity(parent, key)
{
	update(jsonObject);
}

Entity::~Entity()
{
}

const QString& Entity::id() const
{
	if(implementation->primaryKey != nullptr && !implementation->primaryKey->value().isEmpty()) {
		return implementation->primaryKey->value();
	}

	return implementation->id;
}

const QString& Entity::key() const
{
	return implementation->key;
}

void Entity::setPrimaryKey(StringDecorator* primaryKey)
{
	implementation->primaryKey = primaryKey;
}

Entity* Entity::addChild(Entity* entity, const QString& key)
{
	if(implementation->childEntities.find(key) == std::end(implementation->childEntities)) {
		implementation->childEntities[key] = entity;
		emit childEntitiesChanged();
	}

	return entity;
}

EntityCollectionBase* Entity::addChildCollection(EntityCollectionBase* entityCollection)
{
	if(implementation->childCollections.find(entityCollection->getKey()) == std::end(implementation->childCollections)) {
		implementation->childCollections[entityCollection->getKey()] = entityCollection;
		emit childCollectionsChanged(entityCollection->getKey());
	}

	return entityCollection;
}

DataDecorator* Entity::addDataItem(DataDecorator* dataDecorator)
{
	if(implementation->dataDecorators.find(dataDecorator->key()) == std::end(implementation->dataDecorators)) {
		implementation->dataDecorators[dataDecorator->key()] = dataDecorator;
		emit dataDecoratorsChanged();
	}

	return dataDecorator;
}

void Entity::update(const QJsonObject& jsonObject)
{
	if (jsonObject.contains("id")) {
		implementation->id = jsonObject.value("id").toString();
	}

	// Update data decorators
	for (std::pair<QString, DataDecorator*> dataDecoratorPair : implementation->dataDecorators) {
		dataDecoratorPair.second->update(jsonObject);
	}

	// Update child entities
	for (std::pair<QString, Entity*> childEntityPair : implementation->childEntities) {
		childEntityPair.second->update(jsonObject.value(childEntityPair.first).toObject());
	}

	// Update child collections
	for (std::pair<QString, EntityCollectionBase*> childCollectionPair : implementation->childCollections) {
		childCollectionPair.second->update(jsonObject.value(childCollectionPair.first).toArray());
	}
}

QJsonObject Entity::toJson() const
{
	QJsonObject returnValue;
	returnValue.insert("id", implementation->id);

	// Add data decorators
	for (std::pair<QString, DataDecorator*> dataDecoratorPair : implementation->dataDecorators) {
		returnValue.insert( dataDecoratorPair.first, dataDecoratorPair.second->jsonValue() );
	}

	// Add child entities
	for (std::pair<QString, Entity*> childEntityPair : implementation->childEntities) {
		returnValue.insert( childEntityPair.first, childEntityPair.second->toJson() );
	}

	// Add child collections
	for (std::pair<QString, EntityCollectionBase*> childCollectionPair : implementation->childCollections) {
		QJsonArray entityArray;
			for (Entity* entity : childCollectionPair.second->baseEntities()) {
			entityArray.append( entity->toJson() );
		}
		returnValue.insert( childCollectionPair.first, entityArray );
	}

	return returnValue;
}

}}
