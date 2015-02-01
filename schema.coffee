root = global ? window

root.Devices = new Mongo.Collection 'devices'
root.Contexts = new Mongo.Collection 'contexts'
