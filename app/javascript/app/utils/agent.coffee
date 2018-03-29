import superagentPromise from 'superagent-promise'
import _superagent from 'superagent'

superagent = superagentPromise(_superagent, global.Promise)

API_ROOT = '/api'

encode = encodeURIComponent
responseBody = (res) -> res.body

token = null

requests = {
  del: (url) ->
    superagent.del("#{API_ROOT}#{url}").then(responseBody)
  get: (url) ->
    superagent.get("#{API_ROOT}#{url}").then(responseBody)
  put: (url, body) ->
    superagent.put("#{API_ROOT}#{url}", body).then(responseBody)
  post: (url, body) ->
    superagent.post("#{API_ROOT}#{url}", body).then(responseBody)
}


export default {
}
