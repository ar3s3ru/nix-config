{ buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, idasen
,
}:

buildPythonPackage rec {
  pname = "idasen-ha";
  version = "2.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "idasen-ha";
    rev = "refs/tags/v${version}";
    hash = "sha256-lqqSx4jxQVq2pjVv9lvaX6nNK6OqtMjPqOtLMLpVMUU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ idasen ];
}
