


  
AIFRED is a Windows x64 and macOS Apple silicon VST3 plugin for real-time mix analysis, reference
comparison, A/B measurement, and local or remote chat grounded in the current
mix snapshot.

The beta installer contains the VST3, shared DSP contract, self-contained
Intelligence Host, platform-specific Ollama runtime, and AIFRED Modelfile. The Windows installer requires
administrator approval; the macOS installer installs for the current account. During setup, Ollama creates `aifred:latest` from the
bundled Modelfile; Ollama may download the Modelfile's base model, so network
access is required unless that model is already installed.

## Documentation

- [Documentation index](docs/README.md)
- [Installation](docs/INSTALLATION.md)
- [User guide](docs/USER_GUIDE.md)
- [Chat and Intelligence Host](docs/CHAT_AND_INTELLIGENCE.md)
- [Reference mode](docs/REFERENCE_MODE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Development](docs/DEVELOPMENT.md)
- [Release process](docs/RELEASE.md)

### Getting the most accurate mix analysis

AIFRED analyzes a rolling history of recent DSP measurements rather than relying on a single instantaneous meter reading.

When EQ, filters, dynamics, gain, stereo processing, or other effects are being actively adjusted, BufferHunter may capture multiple transitional mix states. Those observations can remain within the recent analysis window for a short period after the adjustment is complete.

For best results, allow your project to play normally for **at least 30 seconds after making significant processing changes** before requesting a new analysis.

This allows the observation window to represent the mix you actually settled on rather than the intermediate states produced whiimport { useAudioEngine } from './hooks/useAudioEngine'
import Analyzer from './components/Analyzer'
import Catalog from './components/Catalog'
import Downloads from './components/Downloads'
import Contact from './components/Contact'
import Ops from './components/Ops'
import ArchitectureExperience from './components/ArchitectureExperience'
import './styles/site.css'
import './styles/architecture.css'
import './styles/application.css'

function Header() {
  return <header className="topbar"><a className="brand" href="/#top"><img className="aifredMascot" src="/assets/brand/aifred-mascot.jpg" alt="" /><span><strong>North3rnLight3r</strong><small>Audio engineering · software</small></span></a>
    <nav aria-label="Main navigation"><a href="#tools">Online tools</a><a href="#vst">AIFRED</a><a href="#analyzer">Analyzer</a><a href="#beats">Beats</a><a href="#downloads">Downloads</a><a href="#contact">Contact</a><a href="/ops">Ops</a></nav></header>
}

function Hero() {
  return <section className="hero" id="top"><div className="hero-copy"><p className="eyebrow">AIFRED · North3rnLight3r</p><h1>Hear it. Measure it. Understand it.</h1>
    <p>Preview beats, analyze audio in your browser, and explore the measured evidence behind AIFRED.</p>
    <div className="actions"><a className="btn" href="#analyzer">Analyze audio</a><a className="btn ghost" href="#beats">Hear the catalog</a><a className="btn ghost" href="#downloads">Get AIFRED</a></div></div>
    <div className="heroArt"><img src="/assets/showcase/album-art-02.jpg" alt="North3rnLight3r album artwork" /></div></section>
}

function Tools() {
  return <section id="tools"><p className="eyebrow">Available now</p><h2>Online tools and services</h2><div className="feature-grid">
    <article><strong>Browser analyzer</strong><span>Live spectrum, waveform, levels, stereo, and a short measurement timeline.</span><a href="#analyzer">Open analyzer</a></article>
    <article><strong>Beat catalog</strong><span>Stream and measure previews. Download MP3 files and ask about commercial licensing.</span><a href="#beats">Browse beats</a></article>
    <article><strong>AIFRED plugin</strong><span>Native VST3 analysis with an evidence pipeline separate from this browser analyzer.</span><a href="#downloads">Download beta</a></article>
    <article><strong>Production work</strong><span>Project based mixing, mastering, custom beats, and software inquiries.</span><a href="#contact">Send an inquiry</a></article>
  </div></section>
}

function Product() {
  return <section id="vst" className="split"><div><p className="eyebrow">AIFRED VST3</p><h2>Measured feedback for your mix.</h2>
    <p>The native plugin analyzes DAW audio without changing it. Engine snapshots become rolling observations, then the filter builds evidence for a separate intelligence host.</p>
    <p>Current source implements the DSP, BufferHunter, filter, and host transport. A future conversational intelligence layer is not presented as a released capability.</p>
    <a className="btn" href="#architecture">Explore the signal path</a></div>
    <figure className="aifred-product-shot"><img src="/assets/showcase/aifred-vst-beta-showcase.png" alt="AIFRED beta interface in FL Studio" loading="lazy" /></figure></section>
}

export default function App() {
  const engine = useAudioEngine()
  if (window.location.pathname === '/ops' || window.location.pathname === '/ops/') return <Ops />
  return <><Header /><main><Hero /><Tools /><Product /><Analyzer engine={engine} /><Catalog engine={engine} /><ArchitectureExperience measurements={engine.measurements} />
    <section id="services"><p className="eyebrow">Studio and software</p><h2>Work with North3rnLight3r</h2><p>Mixing, mastering, custom beat production, and software work are scoped per project. Send the brief and the desired outcome.</p><a className="btn" href="#contact">Discuss a project</a></section>
    <Downloads /><Contact /></main><footer><span>North3rnLight3r</span><span>AIFRED · Browser analyzer · Beat catalog</span><span>© {new Date().getFullYear()}</span></footer></>
}
le adjusting controls.

**Recommended workflow:**

Apply processing → finish the adjustment → play the mix for 30 seconds → request analysis.
