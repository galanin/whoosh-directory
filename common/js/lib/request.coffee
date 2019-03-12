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
  get: (getState, url, params = {}) ->
    session_token = getState().session?.token
    superagent.get("#{baseURL}/user_information/#{url}").query(session_token: session_token).query(params)

  put: (getState, url, params = {}) ->
    session_token = getState().session?.token
    superagent.put("#{baseURL}/user_information/#{url}").send(session_token: session_token).send(params)

  post: (getState, url, params = {}) ->
    session_token = getState().session?.token
    superagent.post("#{baseURL}/user_information/#{url}").query(session_token: session_token).send(params)

  delete: (getState, url, params = {}) ->
    session_token = getState().session?.token
    superagent.delete("#{baseURL}/user_information/#{url}").query(session_token: session_token).send(params)
