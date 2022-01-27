
local M = {}

M.setup = function()
  Metals_config = require("metals").bare_config()

  Metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
      "akka.stream.javadsl",
    },
--    fallbackScalaVersion = "2.13.7",
--    serverVersion = "0.10.9+132-de70f264-SNAPSHOT"
  }

  Metals_config.init_options.statusBarProvider = "on"

  local dap = require("dap")

  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run",
      metals = {
        runType = "run",
        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "RunOrTest",
      metals = {
        runType = "runOrTestFile"
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test File",
      metals = {
        runType = "testFile",
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }

  Metals_config.on_attach = function(client, bufnr)
    vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
    vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
    vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])

    require("metals").setup_dap()
  end

end

return M

