{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage {
  pname = "iroga";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tangtang95";
    repo = "iroga";
    rev = "5aedc8b92dc5fc0d7b6f96608625bc2b88e43308";
    sha256 = "sha256-CTLI2dzVanYgKJ6rANFmOABbRCumyraUcPyC6zkp0No=";
  };

  cargoHash = "sha256-M6H4VAhRJ84zcgflLCfglP8gx5wS5aX0HjlsKrPfgVw=";

  meta = {
    description = "Command line application to pack folder into IRO format (FF7 mod manager file format)";
    license = lib.licenses.mit;
    maintainers = [ "tangtang95" ];
  };
}
