export default {
  fetch: async (req, env) => {
    const { origin, method, hostname, pathname, searchParams } = new URL(req.url)
    const query = Object.fromEntries(searchParams)
    const pathSegments = pathname.split('/')
    const [ name = 'anonymous' ] = pathSegments
    return new Response(JSON.stringify({origin, method, hostname, pathname, query, pathSegments, name}, null, 2))
}
