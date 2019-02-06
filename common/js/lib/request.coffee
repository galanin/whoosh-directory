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


export UserRequest =
  del: (session_token, url, params = {}) ->
    superagent.del("#{baseURL}/user_information#{url}").query(session_token: session_token).query(params)

  get: (session_token, url, params = {}) ->
    superagent.get("#{baseURL}/user_information#{url}").query(session_token: session_token).query(params)

  put: (session_token, url, params = {}) ->
    superagent.put("#{baseURL}/user_information#{url}").send(session_token: session_token).send(params)

  post: (session_token, url, params = {}) ->
    superagent.post("#{baseURL}/user_information#{url}").query(session_token: session_token).send(params)

  delete: (session_token, url, params = {}) ->
      superagent.delete("#{baseURL}/user_information#{url}").query(session_token: session_token).send(params)
