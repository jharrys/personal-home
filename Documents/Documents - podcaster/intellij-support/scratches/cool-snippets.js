// find all immediate methods for Object
getMethods = (obj) => Object.getOwnPropertyNames(obj).filter(
    item => typeof obj[item] === 'function')

// find all methods across Object prototype chain (it dedupes)
const getMethodsAll = (obj) => {
  let properties = new Set()
  let currentObj = obj
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))
  return [...properties.keys()].filter(item => typeof obj[item] === 'function')
}

getMethods({})
getMethods(MediaRecorder)
getMethodsAll(MediaRecorder)
