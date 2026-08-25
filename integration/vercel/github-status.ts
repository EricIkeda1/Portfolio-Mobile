const username = 'EricIkeda1'

export default async function handler(req: any, res: any) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
  res.setHeader('Cache-Control', 's-maxage=300, stale-while-revalidate=600')

  if (req.method === 'OPTIONS') return res.status(204).end()
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  const headers: Record<string, string> = {
    Accept: 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
    'User-Agent': 'EricIkeda-Portfolio',
  }

  if (process.env.GITHUB_TOKEN) {
    headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`
  }

  try {
    const [profileResponse, eventsResponse] = await Promise.all([
      fetch(`https://api.github.com/users/${username}`, { headers }),
      fetch(`https://api.github.com/users/${username}/events/public?per_page=10`, {
        headers,
      }),
    ])

    if (!profileResponse.ok) {
      return res.status(502).json({ error: 'GitHub profile unavailable' })
    }

    const profile = await profileResponse.json()
    const events = eventsResponse.ok ? await eventsResponse.json() : []
    const latest = Array.isArray(events) && events.length ? events[0] : null

    return res.status(200).json({
      username: profile.login,
      profile_url: profile.html_url,
      avatar_url: profile.avatar_url,
      public_repos: profile.public_repos,
      followers: profile.followers,
      last_activity_at: latest?.created_at ?? null,
      last_event_type: latest?.type ?? null,
      last_repository: latest?.repo?.name ?? null,
    })
  } catch (error) {
    console.error(error)
    return res.status(500).json({ error: 'Erro ao consultar GitHub' })
  }
}
