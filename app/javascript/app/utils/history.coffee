import createBrowserHistory from 'history/createBrowserHistory'
import createMemoryHistory from 'history/createMemoryHistory'

createHistory = if global.__SERVER__ then createMemoryHistory else createBrowserHistory

history = createHistory()

export default history
