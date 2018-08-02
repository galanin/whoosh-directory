import superagent from 'superagent'
import superagentJsonapify from 'superagent-jsonapify'

superagentJsonapify(superagent)

baseURL = process.env.API_BASE_URL
throw 'API URL is not defined' unless baseURL?

export encode = encodeURIComponent

export Request =
  del: (url) -> superagent.del("#{baseURL}#{url}")
  get: (url) -> superagent.get("#{baseURL}#{url}")
  put: (url, body) -> superagent.put("#{baseURL}#{url}", body)
  post: (url, body) -> superagent.post("#{baseURL}#{url}", body)
