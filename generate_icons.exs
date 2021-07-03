template_path = "lib/supabase_surface/components/icons/feathericon.eex"
icon_paths = :code.priv_dir(:feathericons) |> Path.join("icons/*.svg") |> Path.wildcard()

for path <- icon_paths do
  function_name =
    Path.basename(path, ".svg")
    |> String.replace("-", "_")

  module_name = Path.basename(path, ".svg") |> String.split("-") |> Enum.map(&String.capitalize/1)
  module_name = "Icon#{module_name}"
  src = EEx.eval_file(template_path, module_name: module_name, function_name: function_name)
  filename = "icon_#{function_name}.ex"
  File.write!("lib/supabase_surface/components/icons/#{filename}", src)
end
