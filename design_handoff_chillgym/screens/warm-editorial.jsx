// Warm Editorial — light theme. Same layout structure as Dark Performance,
// but with Fraunces serif display, Inter body, and the cream/ink/amber palette.
const WE = {
  bg: '#F6F1E7',
  bg2: '#EFE7D5',
  card: '#FFFFFF',
  border: '#E5DCCB',
  ink: '#1B1814',
  ink2: '#5C5247',
  ink3: '#8A8076',
  amber: '#E0A82E',
  amberDeep: '#9A6B12',
  amberPale: '#FBF5E8',
  good: '#3F6B4A',
  rose: '#B5532A',
  sage: '#6B8E76',
  sky: '#3A6B8C',
};
const weBase = {
  fontFamily: '"Inter", system-ui, sans-serif',
  background: WE.bg,
  color: WE.ink,
  width: '100%', height: '100%',
  overflow: 'hidden',
  display: 'flex', flexDirection: 'column',
  boxSizing: 'border-box',
  paddingTop: 54,
};
const weSerif = { fontFamily: '"Fraunces", "Times New Roman", serif', fontOpticalSizing: 'auto' };

function WENav({ leading, trailing, large, sub, title }) {
  return (
    <div style={{ background: WE.bg, padding: '8px 18px 10px', borderBottom: `1px solid ${WE.border}` }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', minHeight: 28 }}>
        <div style={{ fontSize: 14, color: WE.ink2, fontWeight: 500 }}>{leading || ''}</div>
        <div style={{ fontSize: 14, color: WE.ink2, fontWeight: 600 }}>{trailing || ''}</div>
      </div>
      {large && (
        <div style={{ marginTop: 6 }}>
          {sub && <div style={{ fontSize: 10, letterSpacing: '0.18em', textTransform: 'uppercase', color: WE.ink3 }}>{sub}</div>}
          <div style={{ ...weSerif, fontSize: 28, fontWeight: 400, lineHeight: 1.05, marginTop: sub ? 2 : 0, fontStyle: 'italic', letterSpacing: '-0.01em' }}>{title}</div>
        </div>
      )}
    </div>
  );
}

function WETabBar({ active }) {
  const tabs = [
    { k: 'home', label: 'Today',    icon: '◐' },
    { k: 'log',  label: 'Log',      icon: '＋' },
    { k: 'prog', label: 'Progress', icon: '◔' },
    { k: 'cal',  label: 'Calendar', icon: '▦' },
    { k: 'you',  label: 'You',      icon: '○' },
  ];
  return (
    <div style={{ borderTop: `1px solid ${WE.border}`, background: WE.card, padding: '8px 8px 30px', display: 'flex' }}>
      {tabs.map(t => (
        <div key={t.k} style={{ flex: 1, textAlign: 'center', color: t.k === active ? WE.amberDeep : WE.ink3, position: 'relative' }}>
          {t.k === active && <div style={{ position: 'absolute', top: -8, left: '50%', transform: 'translateX(-50%)', width: 18, height: 2, background: WE.amber }} />}
          <div style={{ fontSize: 17 }}>{t.icon}</div>
          <div style={{ fontSize: 10, marginTop: 2, letterSpacing: '0.06em', fontWeight: t.k === active ? 700 : 500, textTransform: 'uppercase' }}>{t.label}</div>
        </div>
      ))}
    </div>
  );
}

function WEScroll({ children }) {
  return <div style={{ flex: 1, overflow: 'auto', padding: '14px 16px 16px' }}>{children}</div>;
}

function WELabel({ children, color = WE.ink3 }) {
  return <div style={{ fontSize: 10, letterSpacing: '0.18em', textTransform: 'uppercase', color, fontWeight: 600 }}>{children}</div>;
}

window.WarmEditorialHome = function () {
  return (
    <div style={weBase}>
      <WENav leading="Thu · 07.05" trailing="EM" large sub="Welcome back" title={<>Encall.</>} />
      <WEScroll>
        <div style={{ position: 'relative', background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 20, padding: 18, overflow: 'hidden' }}>
          <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(circle at 80% 20%, ${WE.amber}22, transparent 60%)` }} />
          <div style={{ position: 'relative', display: 'flex', alignItems: 'center', gap: 14 }}>
            <svg viewBox="0 0 80 80" width="86" height="86">
              <circle cx="40" cy="40" r="34" fill="none" stroke={WE.border} strokeWidth="6" />
              <circle cx="40" cy="40" r="34" fill="none" stroke={WE.amber} strokeWidth="6" strokeLinecap="round" strokeDasharray={`${(12/14)*213} 213`} transform="rotate(-90 40 40)" />
              <text x="40" y="40" textAnchor="middle" fontSize="24" fontWeight="400" fill={WE.ink} fontFamily="Fraunces, serif" fontStyle="italic">12</text>
              <text x="40" y="54" textAnchor="middle" fontSize="7" fill={WE.ink3} letterSpacing="2">DAYS</text>
            </svg>
            <div style={{ flex: 1 }}>
              <WELabel color={WE.amberDeep}>● ON FIRE</WELabel>
              <div style={{ ...weSerif, fontSize: 20, fontStyle: 'italic', marginTop: 2 }}>12-day streak</div>
              <div style={{ fontSize: 12, color: WE.ink2, marginTop: 2 }}>2 days from your record</div>
              <div style={{ display: 'flex', gap: 3, marginTop: 8 }}>
                {Array.from({ length: 14 }).map((_, i) => (
                  <div key={i} style={{ flex: 1, height: 4, borderRadius: 2, background: i < 12 ? WE.amber : WE.border }} />
                ))}
              </div>
            </div>
          </div>
        </div>

        <div style={{ marginTop: 12, background: WE.ink, color: WE.bg, borderRadius: 20, padding: 18, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontSize: 10, fontWeight: 600, letterSpacing: '0.16em', opacity: 0.7 }}>NEXT UP</div>
            <div style={{ ...weSerif, fontSize: 24, fontStyle: 'italic', marginTop: 2 }}>Push Day · A</div>
            <div style={{ fontSize: 11, opacity: 0.7, letterSpacing: '0.06em' }}>5 EXERCISES · ~52 MIN</div>
          </div>
          <div style={{ width: 50, height: 50, background: WE.amber, color: WE.ink, borderRadius: 999, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 20 }}>▶</div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginTop: 12 }}>
          {[
            { l: '7-DAY VOLUME', n: '24.3', u: 't',   c: WE.sage,      spark: [10,15,12,22,28,32,35] },
            { l: 'EST 1RM',      n: '104',  u: 'kg',  c: WE.amberDeep, spark: [4,8,10,12,18,22,28] },
            { l: 'BODYWEIGHT',   n: '78.2', u: 'kg',  c: WE.sky,       spark: [30,28,26,28,26,24,22] },
            { l: 'SESSIONS',     n: '5',    u: '/wk', c: WE.rose,      spark: [10,18,14,22,18,28,30] },
          ].map((m, i) => (
            <div key={i} style={{ background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 16, padding: 14 }}>
              <WELabel color={m.c}>{m.l}</WELabel>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 4, marginTop: 4 }}>
                <div style={{ ...weSerif, fontSize: 26, fontWeight: 400, fontVariantNumeric: 'tabular-nums' }}>{m.n}</div>
                <div style={{ fontSize: 11, color: WE.ink3 }}>{m.u}</div>
              </div>
              <svg viewBox="0 0 70 24" style={{ width: '100%', height: 24, marginTop: 4 }}>
                <polyline fill="none" stroke={m.c} strokeWidth="1.5" points={m.spark.map((v, j) => `${j*10},${24-v*0.6}`).join(' ')} />
              </svg>
            </div>
          ))}
        </div>

        <div style={{ marginTop: 16 }}>
          <WELabel>RECENT</WELabel>
          {[
            { d: '05.05', t: 'Pull', s: '14 sets · 4.24 t', c: WE.amberDeep },
            { d: '03.05', t: 'Legs', s: '12 sets · 6.11 t', c: WE.sky  },
            { d: '01.05', t: 'Push', s: '15 sets · 3.98 t', c: WE.rose  },
          ].map((r, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '12px 0', borderBottom: `1px solid ${WE.border}` }}>
              <div style={{ width: 40, fontSize: 11, color: WE.ink3, fontVariantNumeric: 'tabular-nums' }}>{r.d}</div>
              <div style={{ flex: 1 }}>
                <div style={{ ...weSerif, fontSize: 16, fontStyle: 'italic' }}>{r.t}</div>
                <div style={{ fontSize: 11, color: WE.ink3 }}>{r.s}</div>
              </div>
              <div style={{ color: r.c }}>›</div>
            </div>
          ))}
        </div>
      </WEScroll>
      <WETabBar active="home" />
    </div>
  );
};

window.WarmEditorialActive = function () {
  return (
    <div style={weBase}>
      <WENav leading="‹ Workout" trailing="34:12" />
      <div style={{ padding: '12px 16px', background: WE.amberPale, borderBottom: `1px solid ${WE.border}`, display: 'flex', alignItems: 'center', gap: 12 }}>
        <svg viewBox="0 0 80 80" width="64" height="64">
          <circle cx="40" cy="40" r="34" fill="none" stroke={WE.border} strokeWidth="5" />
          <circle cx="40" cy="40" r="34" fill="none" stroke={WE.amber} strokeWidth="5" strokeLinecap="round" strokeDasharray={`${0.46*213} 213`} transform="rotate(-90 40 40)" />
        </svg>
        <div style={{ flex: 1 }}>
          <WELabel color={WE.amberDeep}>RESTING</WELabel>
          <div style={{ ...weSerif, fontSize: 30, fontWeight: 400, fontVariantNumeric: 'tabular-nums', marginTop: -2 }}>1:24</div>
        </div>
        <div style={{ display: 'flex', gap: 6 }}>
          <div style={{ background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 999, padding: '6px 12px', fontSize: 11, fontWeight: 600 }}>+15s</div>
          <div style={{ background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 999, padding: '6px 12px', fontSize: 11, fontWeight: 600 }}>Skip</div>
        </div>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '14px 14px 12px' }}>
        <div style={{ background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 20, padding: 16 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <WELabel color={WE.amberDeep}>EXERCISE 3 OF 5</WELabel>
              <div style={{ ...weSerif, fontSize: 24, fontStyle: 'italic', marginTop: 2 }}>Bench Press</div>
              <div style={{ fontSize: 11, color: WE.ink3 }}>Barbell · Chest</div>
            </div>
            <div style={{ background: WE.amberPale, color: WE.amberDeep, padding: '4px 10px', borderRadius: 999, fontSize: 10, fontWeight: 700, letterSpacing: '0.1em', border: `1px solid ${WE.amber}55` }}>+8 KG</div>
          </div>
          <div style={{ marginTop: 12 }}>
            {[
              [1, '60', '10', '3', true],
              [2, '80', '8',  '2', true],
              [3, '85', '6',  '1', true],
              [4, '85', '—',  '—', false],
            ].map(r => (
              <div key={r[0]} style={{ display: 'grid', gridTemplateColumns: '24px 1fr 1fr 1fr 28px', alignItems: 'center', padding: '10px 0', borderBottom: `1px solid ${WE.border}`, fontVariantNumeric: 'tabular-nums' }}>
                <div style={{ ...weSerif, fontSize: 12, fontStyle: 'italic', color: WE.ink3 }}>{r[0]}</div>
                <div style={{ ...weSerif, fontSize: 17, fontWeight: 400, color: r[4] ? WE.ink : WE.ink3 }}>{r[1]} <span style={{ fontSize: 11, color: WE.ink3, fontFamily: 'Inter' }}>kg</span></div>
                <div style={{ ...weSerif, fontSize: 17, fontWeight: 400, color: r[4] ? WE.ink : WE.ink3 }}>{r[2]}</div>
                <div style={{ fontSize: 12, color: WE.ink3 }}>RIR {r[3]}</div>
                <div style={{ color: r[4] ? WE.good : WE.amberDeep, textAlign: 'right' }}>{r[4] ? '✓' : '○'}</div>
              </div>
            ))}
          </div>
          <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
            <div style={{ flex: 1, background: WE.ink, color: WE.bg, padding: '12px 0', borderRadius: 12, textAlign: 'center', fontWeight: 700, fontSize: 12, letterSpacing: '0.12em', textTransform: 'uppercase' }}>＋ Add Set</div>
            <div style={{ background: WE.card, color: WE.ink, padding: '12px 16px', borderRadius: 12, fontSize: 13, border: `1px solid ${WE.border}`, fontWeight: 600 }}>↻</div>
          </div>
        </div>

        <div style={{ marginTop: 12, background: WE.amberPale, border: `1px solid ${WE.amber}55`, borderRadius: 16, padding: 14, borderLeft: `3px solid ${WE.amber}` }}>
          <WELabel color={WE.amberDeep}>● THAT'S GOOD</WELabel>
          <div style={{ ...weSerif, fontSize: 14, fontStyle: 'italic', marginTop: 4 }}>"Volume in line with your 4-week average. Try <span style={{ color: WE.amberDeep, fontWeight: 600, fontStyle: 'normal' }}>+2.5 kg</span> next session."</div>
        </div>

        <div style={{ marginTop: 14 }}>
          <WELabel>UP NEXT</WELabel>
          {['Incline DB Press · 3×10', 'Cable Fly · 3×12', 'Triceps Pushdown · 3×12'].map((x, i) => (
            <div key={i} style={{ padding: '10px 0', borderBottom: `1px solid ${WE.border}`, ...weSerif, fontSize: 15, color: WE.ink2 }}>{x}</div>
          ))}
        </div>
      </div>

      <div style={{ display: 'flex', gap: 8, padding: '10px 14px 30px', background: WE.card, borderTop: `1px solid ${WE.border}` }}>
        <div style={{ flex: 1, background: WE.ink, color: WE.bg, padding: '14px 0', borderRadius: 14, textAlign: 'center', fontWeight: 600, fontSize: 12, letterSpacing: '0.14em', textTransform: 'uppercase' }}>Finish</div>
        <div style={{ background: WE.bg, color: WE.ink, padding: '14px 18px', borderRadius: 14, fontWeight: 600, fontSize: 13, border: `1px solid ${WE.border}` }}>Next →</div>
      </div>
    </div>
  );
};

window.WarmEditorialProgress = function () {
  const points = [40,55,52,60,58,68,72,78,82,88,94,104];
  return (
    <div style={weBase}>
      <WENav leading="Progress" trailing="Bench ▾" large sub="Last 12 weeks" title={<><em>Onward,</em> upward.</>} />
      <WEScroll>
        <div style={{ background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 20, padding: 18, position: 'relative', overflow: 'hidden' }}>
          <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(ellipse at 100% 0%, ${WE.amber}22, transparent 50%)` }} />
          <div style={{ position: 'relative' }}>
            <WELabel>EST 1RM</WELabel>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
              <div style={{ ...weSerif, fontSize: 56, fontWeight: 300, letterSpacing: '-0.02em', lineHeight: 0.9 }}>104</div>
              <div style={{ fontSize: 14, color: WE.ink3 }}>kg</div>
              <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 4, color: WE.good, fontWeight: 700, fontSize: 13 }}>↑ +8 kg</div>
            </div>
            <svg viewBox="0 0 320 110" style={{ width: '100%', height: 110, marginTop: 8 }}>
              <defs>
                <linearGradient id="we-grad" x1="0" x2="0" y1="0" y2="1">
                  <stop offset="0%" stopColor={WE.amber} stopOpacity="0.5" />
                  <stop offset="100%" stopColor={WE.amber} stopOpacity="0" />
                </linearGradient>
              </defs>
              {[0,1,2,3].map(i => <line key={i} x1="0" x2="320" y1={i*28} y2={i*28} stroke={WE.border} />)}
              <path d={`M${points.map((v, j) => `${j*29},${100 - (v-30)*1.0}`).join(' L')} L${(points.length-1)*29},110 L0,110 Z`} fill="url(#we-grad)" />
              <path d={`M${points.map((v, j) => `${j*29},${100 - (v-30)*1.0}`).join(' L')}`} fill="none" stroke={WE.amberDeep} strokeWidth="2" />
              {points.map((v, j) => j === points.length-1 && (
                <circle key={j} cx={j*29} cy={100-(v-30)*1.0} r="4" fill={WE.amberDeep} />
              ))}
            </svg>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 6, marginTop: 12 }}>
          {['1M','3M','6M','1Y','ALL'].map((r, i) => (
            <div key={r} style={{ flex: 1, textAlign: 'center', padding: '8px 0', borderRadius: 10, background: i === 1 ? WE.amberPale : WE.card, color: i === 1 ? WE.amberDeep : WE.ink3, fontSize: 11, fontWeight: 700, border: `1px solid ${i === 1 ? WE.amber+'66' : WE.border}` }}>{r}</div>
          ))}
        </div>

        <div style={{ marginTop: 16 }}>
          <WELabel>PERSONAL BESTS</WELabel>
          <div style={{ marginTop: 8, background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 16, overflow: 'hidden' }}>
            {[
              ['Bench Press', '95 kg × 5',         WE.amberDeep, true],
              ['Deadlift',    '160 kg × 3',        WE.sage,      true],
              ['Squat',       '130 kg × 6',        WE.sky,       false],
              ['Pull-up',     'BW + 22.5 × 5',     WE.rose,      true],
            ].map((p, i, arr) => (
              <div key={i} style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12, borderBottom: i < arr.length - 1 ? `1px solid ${WE.border}` : 'none' }}>
                <div style={{ width: 4, height: 28, background: p[2], borderRadius: 2 }} />
                <div style={{ flex: 1 }}>
                  <div style={{ ...weSerif, fontSize: 16, fontStyle: 'italic' }}>{p[0]}</div>
                  <div style={{ fontSize: 12, color: WE.ink3, fontVariantNumeric: 'tabular-nums' }}>{p[1]}</div>
                </div>
                {p[3] && <div style={{ background: WE.amberPale, color: WE.amberDeep, padding: '4px 10px', borderRadius: 999, fontSize: 10, fontWeight: 700, letterSpacing: '0.1em', border: `1px solid ${WE.amber}55` }}>★ NEW</div>}
              </div>
            ))}
          </div>
        </div>
      </WEScroll>
      <WETabBar active="prog" />
    </div>
  );
};

window.WarmEditorialCalendar = function () {
  const dows = [{k:'mo',l:'M'},{k:'tu',l:'T'},{k:'we',l:'W'},{k:'th',l:'T'},{k:'fr',l:'F'},{k:'sa',l:'S'},{k:'su',l:'S'}];
  return (
    <div style={weBase}>
      <WENav leading="‹ ›" trailing="May" large sub="May 2026" title={<><em>17</em> days · 5/wk</>} />
      <WEScroll>
        <div style={{ background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 20, padding: 16 }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 6, marginBottom: 8 }}>
            {dows.map(d => <div key={d.k} style={{ textAlign: 'center', fontSize: 10, color: WE.ink3, letterSpacing: '0.1em' }}>{d.l}</div>)}
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 6 }}>
            {Array.from({ length: 35 }).map((_, i) => {
              const v = (i*7+3) % 9;
              const has = v >= 4;
              const intensity = v < 4 ? 0 : v < 6 ? 0.35 : v < 8 ? 0.7 : 1;
              const sel = i === 17;
              return (
                <div key={i} style={{ aspectRatio: '1', borderRadius: 8, background: has ? `rgba(224,168,46,${intensity})` : WE.bg2, border: sel ? `1.5px solid ${WE.amberDeep}` : `1px solid ${WE.border}`, color: has && intensity > 0.6 ? WE.ink : WE.ink2, fontSize: 11, fontWeight: 600, display: 'flex', alignItems: 'center', justifyContent: 'center', fontVariantNumeric: 'tabular-nums' }}>
                  {(i % 31) + 1}
                </div>
              );
            })}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 12, fontSize: 10, color: WE.ink3, letterSpacing: '0.1em' }}>
            <span>LESS</span>
            {[0,0.35,0.7,1].map((a,i)=> <div key={i} style={{ width: 14, height: 14, borderRadius: 4, background: a===0?WE.bg2:`rgba(224,168,46,${a})`, border: `1px solid ${WE.border}` }} />)}
            <span>MORE</span>
          </div>
        </div>

        <div style={{ marginTop: 12, background: WE.card, border: `1px solid ${WE.border}`, borderRadius: 20, padding: 16 }}>
          <WELabel color={WE.amberDeep}>● 05.05 · TUESDAY</WELabel>
          <div style={{ ...weSerif, fontSize: 20, fontStyle: 'italic', marginTop: 4 }}>Pull Day</div>
          <div style={{ fontSize: 12, color: WE.ink3 }}>ChillGym Central · 62 min</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginTop: 12 }}>
            {[['SETS', '14', WE.sage], ['VOLUME', '4.24t', WE.amberDeep], ['MAX', '110kg', WE.sky]].map((s, i) => (
              <div key={i} style={{ background: WE.bg2, borderRadius: 12, padding: 10, border: `1px solid ${WE.border}` }}>
                <div style={{ fontSize: 9, letterSpacing: '0.14em', color: s[2], fontWeight: 700 }}>{s[0]}</div>
                <div style={{ ...weSerif, fontSize: 20, fontWeight: 400, marginTop: 2, fontVariantNumeric: 'tabular-nums' }}>{s[1]}</div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ marginTop: 12, background: WE.amberPale, border: `1px solid ${WE.amber}55`, borderRadius: 16, padding: 14, borderLeft: `3px solid ${WE.amber}` }}>
          <WELabel color={WE.amberDeep}>★ NEW PR</WELabel>
          <div style={{ ...weSerif, fontSize: 15, fontStyle: 'italic', marginTop: 4 }}>Pull-up · BW + 22.5 kg × 5</div>
        </div>
      </WEScroll>
      <WETabBar active="cal" />
    </div>
  );
};
