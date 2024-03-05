import { Miniflare, Response } from "miniflare";

const message = "The count is ";
const mf = new Miniflare({
  // Options shared between workers such as HTTP and persistence configuration
  // should always be defined at the top level.
  host: "0.0.0.0",
  port: 8787,
  kvPersist: true,

  workers: [
    {
      name: "worker",
      kvNamespaces: { COUNTS: "counts" },
      serviceBindings: {
        INCREMENTER: "incrementer",
        // Service bindings can also be defined as custom functions, with access
        // to anything defined outside Miniflare.
        async CUSTOM(request) {
          // `request` is the incoming `Request` object.
          return new Response(message);
        },
      },
      modules: true,
      script: `export default {
        async fetch(request, env, ctx) {
          // Get the message defined outside
          const response = await env.CUSTOM.fetch("http://host/");
          const message = await response.text();

          // Increment the count 3 times
          await env.INCREMENTER.fetch("http://host/");
          await env.INCREMENTER.fetch("http://host/");
          await env.INCREMENTER.fetch("http://host/");
          const count = await env.COUNTS.get("count");

          return new Response(message + count);
        }
      }`,
    },
    {
      name: "incrementer",
      // Note we're using the same `COUNTS` namespace as before, but binding it
      // to `NUMBERS` instead.
      kvNamespaces: { NUMBERS: "counts" },
      // Worker formats can be mixed-and-matched
      script: `addEventListener("fetch", (event) => {
        event.respondWith(handleRequest());
      })
      async function handleRequest() {
        const count = parseInt((await NUMBERS.get("count")) ?? "0") + 1;
        await NUMBERS.put("count", count.toString());
        return new Response(count.toString());
      }`,
    },
  ],
});
const res = await mf.dispatchFetch("http://localhost");
//console.log(await res.text()); // "The count is 3"
await mf.dispose();