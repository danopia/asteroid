root = global ? window

root.Contexts = new Mongo.Collection 'contexts'
root.Devices = new Mongo.Collection 'devices'
root.Objects = new Mongo.Collection 'objects'
