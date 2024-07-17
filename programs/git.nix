{
  enable = true;
  userName = "Tangtang Zhou";
  userEmail = "tangtang2995@gmail.com";
  aliases = {
    pfl = "push --force-with-lease";
    log1l = "log --oneline";
    logp = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    branch-merged = "!git branch --merged | grep  -v '\\*\\|master\\|main'";
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
