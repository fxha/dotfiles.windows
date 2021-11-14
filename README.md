# Dotfiles

Additional configuration files for Windows. If you're using Unix, check out my [dotfiles](https://github.com/fxha/dotfiles).

## Installing

Replace your PowerShell profile with `Microsoft.PowerShell_profile.ps1` and install all module dependencies (`setup/deps.ps1`).

You also need to configure the execution policy to allow the execution of PowerShell scripts:

```powershell
PS > Set-ExecutionPolicy RemoteSigned
```

### Dependencies

**Modules:**

- Get-ChildItemColor
- Posh-Git
- posh-sshell
- PSReadLine

**Software:**

- Git for Windows is recommended
- Windows built-in OpenSSH service should be enabled

## License

[MIT license](LICENSE)
