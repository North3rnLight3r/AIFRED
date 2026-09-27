import AppKit

final class Installer: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    var button: NSButton!
    var status: NSTextField!
    var log: NSTextView!
    var running = false
    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 640, height: 440),
                          styleMask: [.titled, .closable, .miniaturizable], backing: .buffered, defer: false)
        window.title = "AIFRED VST3 beta"
        window.delegate = self
        window.center()
        let view = window.contentView!
        let title = NSTextField(labelWithString: "Install AIFRED VST3 beta")
        title.font = .boldSystemFont(ofSize: 24)
        title.frame = NSRect(x: 24, y: 385, width: 590, height: 32)
        view.addSubview(title)
        status = NSTextField(wrappingLabelWithString: "Installs the VST3 plugin, Intelligence Host and local chat runtime for this account. Internet is required to download the base model. Close your DAW before installing.")
        status.frame = NSRect(x: 24, y: 310, width: 590, height: 65)
        view.addSubview(status)
        let scroll = NSScrollView(frame: NSRect(x: 24, y: 75, width: 590, height: 220))
        scroll.hasVerticalScroller = true
        log = NSTextView(frame: scroll.bounds)
        log.isEditable = false
        log.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        scroll.documentView = log
        view.addSubview(scroll)
        button = NSButton(title: "Install", target: self, action: #selector(install))
        button.bezelStyle = .rounded
        button.frame = NSRect(x: 490, y: 22, width: 124, height: 34)
        view.addSubview(button)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    @objc func install() {
        if button.title == "Done" { NSApp.terminate(nil); return }
        running = true
        button.isEnabled = false
        status.stringValue = "Installing… Model download can take several minutes. Keep this window open."
        let resources = Bundle.main.resourceURL!
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [resources.appendingPathComponent("install-payload.sh").path,
                             resources.appendingPathComponent("payload").path]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if data.isEmpty { handle.readabilityHandler = nil; return }
            let message = String(decoding: data, as: UTF8.self)
            DispatchQueue.main.async {
                self.log.textStorage?.append(NSAttributedString(string: message))
                self.log.scrollToEndOfDocument(nil)
            }
        }
        process.terminationHandler = { task in
            DispatchQueue.main.async {
                self.running = false
                self.button.isEnabled = true
                let ok = task.terminationStatus == 0
                self.button.title = ok ? "Done" : "Retry"
                self.status.stringValue = ok
                    ? "Installed. Local chat is ready. Rescan VST3 plugins in your DAW to load AIFRED."
                    : "Installation failed. Review the log below, correct the problem, and retry. Log: ~/Library/Application Support/Aifred/beta/logs/install.log"
            }
        }
        do { try process.run() }
        catch {
            running = false
            button.isEnabled = true
            status.stringValue = "Cannot start installer: \(error.localizedDescription)"
        }
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool { return !running }
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return running ? .terminateCancel : .terminateNow
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { return true }
}
let app = NSApplication.shared
let delegate = Installer()
app.setActivationPolicy(.regular)
app.delegate = delegate
app.run()
