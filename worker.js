export default {
  fetch: async (req, env) => {
    const {name} = await env.CTX.fetch(req).then(res => res.json())
    return new Response(JSON.stringify({hello: world}, null, 2))
}
