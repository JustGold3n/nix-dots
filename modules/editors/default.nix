{ hey, lib, config, ... }:

with lib;
with hey.lib;
let cfg = config.modules.editors;
in {
  options.modules.editors = {
    default = mkOpt types.str "nvim";
  };

  config = mkIf (cfg.default != null) {
    environment.variables.EDITOR = cfg.default;
    environment.shellAliases = {
      vi = cfg.default;
      vim = cfg.default;
    };
  };
}
