import yn from "yn";
import superagent from "superagent";
import superagentJsonapify from "superagent-jsonapify";

superagentJsonapify(superagent);

const baseURL = yn(process.env.SSR)
  ? process.env.SERVER_SIDE_API_BASE_URL
  : process.env.CLIENT_SIDE_API_BASE_URL;
if (baseURL == null) {
  throw "API URL is not defined";
}

export const encode = encodeURIComponent;

export const Request = {
  del(url, params) {
    if (params == null) {
      params = {};
    }
    return superagent.del(`${baseURL}${url}`).query(params);
  },

  get(url, params) {
    if (params == null) {
      params = {};
    }
    return superagent.get(`${baseURL}${url}`).query(params);
  },

  put(url, params) {
    if (params == null) {
      params = {};
    }
    return superagent.put(`${baseURL}${url}`).send(params);
  },

  post(url, params) {
    if (params == null) {
      params = {};
    }
    return superagent.post(`${baseURL}${url}`).send(params);
  }
};

export const UserRequest = {
  get(getState, url, params) {
    if (params == null) {
      params = {};
    }
    const session_token = __guard__(getState().session, x => x.token);
    return superagent
      .get(`${baseURL}/user_information/${url}`)
      .query({ session_token })
      .query(params);
  },

  put(getState, url, params) {
    if (params == null) {
      params = {};
    }
    const session_token = __guard__(getState().session, x => x.token);
    return superagent
      .put(`${baseURL}/user_information/${url}`)
      .send({ session_token })
      .send(params);
  },

  post(getState, url, params) {
    if (params == null) {
      params = {};
    }
    const session_token = __guard__(getState().session, x => x.token);
    return superagent
      .post(`${baseURL}/user_information/${url}`)
      .query({ session_token })
      .send(params);
  },

  delete(getState, url, params) {
    if (params == null) {
      params = {};
    }
    const session_token = __guard__(getState().session, x => x.token);
    return superagent
      .delete(`${baseURL}/user_information/${url}`)
      .query({ session_token })
      .send(params);
  }
};

const __guard__ = (value, transform) => {
  return typeof value !== "undefined" && value !== null
    ? transform(value)
    : undefined;
};
