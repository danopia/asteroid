root = global ? window

root.Contexts = new Mongo.Collection 'contexts'
root.Devices = new Mongo.Collection 'configs'
root.Objects = new Mongo.Collection 'devices'
