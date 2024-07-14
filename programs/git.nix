{
  enable = true;
  userName = "Tangtang Zhou";
  userEmail = "tangtang2995@gmail.com";
  aliases = {
    pfl = "push --force-with-lease";
    log1l = "log --oneline";
  };
  delta = {
    enable = true;
  };
  extraConfig = {
    core = {
      editor = "nvim";
    };
    push = {
      default = "current";
      autoSetupRemote = true;
    };
    pull = {
      rebase = true;
    };
    delta = {
      navigate = true;
    };
    merge.tool = "nvimdiff";
    mergetool = {
      prompt = false;
      keepBackup = false;
    };
    "mergetool \"vimdiff\"".layout = "LOCAL,MERGED,REMOTE";
    init = {
      defaultBranch = "main";
    };
    credential.helper = "store";
  };
}
