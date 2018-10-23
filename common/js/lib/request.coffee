import superagent from 'superagent'
import superagentJsonapify from 'superagent-jsonapify'

superagentJsonapify(superagent)

baseURL = process.env.API_BASE_URL
throw 'API URL is not defined' unless baseURL?

export encode = encodeURIComponent

export Request =
  del: (url, params = {}) ->
    superagent.del("#{baseURL}#{url}").query(params)

  get: (url, params = {}) ->
    superagent.get("#{baseURL}#{url}").query(params)

  put: (url, params = {}) ->
    superagent.put("#{baseURL}#{url}").send(params)

  post: (url, params = {}) ->
    superagent.post("#{baseURL}#{url}").send(params)
