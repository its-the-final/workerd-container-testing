using Workerd = import "/workerd/workerd.capnp";

const config :Workerd.Config = (
  services = [
    (name = "main", worker = .mainWorker),
   # (name = "ctx", worker = .ctxWorker),
  ],

  sockets = [
    # Serve HTTP on port 8080.
    ( name = "http",
      address = "*:8080",
      http = (),
      service = "main"
    ),
  ]
);

const mainWorker :Workerd.Worker = (
  compatibilityDate = "2022-09-16",

  modules = [
    ( name = "worker.js", esModule = embed "worker.js" ),
  ],
  bindings = [
    ( name = "CTX", service = ( name = "ctx" ) ),
  ],
);

#const testWorker :Workerd.Worker = (
#  compatibilityDate = "2022-09-16",
#
#  modules = [
#    ( name = "ctx.js", esModule = embed "ctx.js" ),
#  ],
#);
