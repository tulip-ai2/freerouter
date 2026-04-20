# 🚂 Deploy FreeRouter on Railway

This guide shows how to deploy **FreeRouter** — a Railway-ready fork of 9Router — on [Railway](https://railway.app) for free hosting.

## Prerequisites

- [Railway](https://railway.app) account (free tier available)
- GitHub account
- AI Provider API keys (optional — app works with free models too)

---

## ⚡ One-Click Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new?template=https://github.com/YOUR_USERNAME/freerouter)

> Replace `YOUR_USERNAME` with your GitHub username after forking.

---

## 🛠️ Manual Deploy

### Step 1: Fork this Repository

1. Click **Fork** on GitHub
2. Name it `freerouter` (or anything you like)
3. Note your fork URL: `https://github.com/YOUR_USERNAME/freerouter`

### Step 2: Create Railway Project

1. Go to [railway.app](https://railway.app) → **New Project**
2. Select **Deploy from GitHub repo**
3. Authorize GitHub if needed
4. Choose your `freerouter` fork
5. Railway auto-detects the `Dockerfile` and `railway.toml`

### Step 3: Configure Environment Variables

In Railway dashboard → **Variables**, add:

| Variable | Value | Required |
|----------|-------|----------|
| `JWT_SECRET` | A strong random string (32+ chars) | ✅ **Required** |
| `INITIAL_PASSWORD` | Your admin password | ✅ **Required** |
| `NODE_ENV` | `production` | Recommended |
| `DATA_DIR` | `/var/lib/freerouter` | Default |

**Provider API Keys** (add as needed):

```
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=...
GROQ_API_KEY=...
OPENROUTER_API_KEY=...
```

### Step 4: Deploy

Railway will:
1. Clone your repo
2. Build the Docker image (Next.js + Bun runtime)
3. Start the server on the assigned port
4. Auto-detect health check at `/`

Click **Deploy** and wait ~2-3 minutes.

---

## 🌐 Accessing Your Deployment

After deploy, Railway provides a public URL:

```
https://your-app.railway.app
```

### CLI Access (for Claude Code, Codex, etc.)

```bash
# Set environment variable
export ANTHROPIC_BASE_URL="https://your-app.railway.app/v1"
export ANTHROPIC_AUTH_TOKEN="your-jwt-token"

# Or via CLI
claude code --anthropic-base-url "https://your-app.railway.app/v1"
```

### Admin Dashboard

1. Visit `https://your-app.railway.app`
2. Login with `INITIAL_PASSWORD` you set
3. Configure providers and start routing!

---

## ⚙️ How It Works

```
User CLI Tool  →  FreeRouter (Railway)  →  AI Provider
                      ↓
              Subscription (primary)
                    ↓ fail
              Cheap model fallback
                    ↓ fail
              Free model fallback
```

**Railway provides:**
- `PORT` — dynamic port assigned at runtime
- `RAILWAY_PUBLIC_DOMAIN` — your app's public URL
- `RAILWAY_PRIVATE_DOMAIN` — internal network address

FreeRouter auto-detects these and configures the router accordingly.

---

## 🔧 Troubleshooting

### App shows "Connection Refused"
- Check Railway logs: click **Deployments** → **Logs**
- Verify `JWT_SECRET` and `INITIAL_PASSWORD` are set
- Make sure `PORT` is not hardcoded (Railway assigns dynamically)

### Build fails
- Ensure `Dockerfile` is in repo root
- Check `railway.toml` has `builder = "DOCKERFILE"`
- Verify Node.js/Bun dependencies in `package.json`

### Can't login
- Reset `INITIAL_PASSWORD` in Railway Variables
- Restart the deployment (Deployments → ⋮ → Restart)

### 502 Bad Gateway
- App is still starting — wait 30s and refresh
- Check if `PORT` environment variable is set correctly

---

## 📁 Key Files for Railway

| File | Purpose |
|------|---------|
| `railway.json` | Railway template config (build: Dockerfile, deploy: start cmd, health check) |
| `Dockerfile` | Multi-stage build with Bun + Next.js |
| `start.sh` | Init script (sets up data dir, validates env) |
| `.env.example` | Template for environment variables |

---

## 🔒 Security Notes

- **Always set `JWT_SECRET`** to a strong random value
- Use `AUTH_COOKIE_SECURE=true` in production (Railway provides HTTPS)
- Keep API keys in Railway Variables, not in code
- The app runs behind Railway's edge network — no extra firewall needed

---

## 💡 Tips

- **Custom domain**: Railway → Settings → Networking → Add Domain
- **Zero cold starts**: Enable Railway Pro or use their minimum replica config
- **Logs**: Real-time logs available in Railway dashboard
- **Metrics**: Built-in CPU, memory, request graphs

---

## 🙏 Credits

FreeRouter is a Railway-ready fork of [9Router](https://github.com/decolua/9router) by [Decolua](https://github.com/decolua).

Railway template by Black Rose 🌹
