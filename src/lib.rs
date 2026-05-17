use zed_extension_api::{self as zed, Command, LanguageServerId, Worktree};

struct JerryExtension;

impl zed::Extension for JerryExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &Worktree,
    ) -> zed::Result<Command> {
        let jerry = worktree.which("jerry").ok_or_else(|| {
            "jerry not found in PATH. Install with: go install github.com/jeffscottbrown/jerry-lang/cmd/jerry@latest".to_string()
        })?;
        Ok(Command {
            command: jerry,
            args: vec!["lsp".to_string()],
            env: vec![],
        })
    }
}

zed::register_extension!(JerryExtension);
