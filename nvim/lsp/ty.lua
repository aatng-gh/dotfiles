return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = {
    'ty.toml',
    'pyproject.toml',
    'uv.lock',
    '.git',
  },
  settings = {
    ty = {
      diagnosticMode = 'openFilesOnly',
    },
  },
}
