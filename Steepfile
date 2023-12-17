D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib"                       # Directory name

  repo_path ".gem_rbs_collection"
  library "activerecord"

  configure_code_diagnostics(D::Ruby.all_error)
end
