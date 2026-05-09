// Dark Performance — dark theme. Same brand identity as Warm Editorial.
// Same layout primitives: status-bar inset, top nav, content scroll, bottom tabs.
const DP = {
  bg: '#0B0B0F',
  bg2: '#13141A',
  card: '#1A1B22',
  border: '#262833',
  ink: '#F1EFE8',
  ink2: '#9C9DA8',
  ink3: '#6E6F7A',
  amber: '#FFB627',
  amberDim: '#3A2E10',
  lime: '#C8FF00',
  pink: '#FF4D8D',
  cyan: '#5BE9F2',
  good: '#3F8E5C',
};
const dpBase = {
  fontFamily: '"Inter", system-ui, sans-serif',
  background: DP.bg,
  color: DP.ink,
  width: '100%', height: '100%',
  overflow: 'hidden',
  display: 'flex', flexDirection: 'column',
  boxSizing: 'border-box',
  paddingTop: 54,
};
const dpSerif = { fontFamily: '"Fraunces", "Times New Roman", serif', fontOpticalSizing: 'auto' };

function DPNav({ leading, trailing, large, sub, title }) {
  return (
    <div style={{ background: DP.bg, padding: '8px 18px 10px', borderBottom: `1px solid ${DP.border}` }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', minHeight: 28 }}>
        <div style={{ fontSize: 14, color: DP.ink2, fontWeight: 500 }}>{leading || ''}</div>
        <div style={{ fontSize: 14, color: DP.ink2, fontWeight: 600 }}>{trailing || ''}</div>
      </div>
      {large && (
        <div style={{ marginTop: 6 }}>
          {sub && <div style={{ fontSize: 10, letterSpacing: '0.18em', textTransform: 'uppercase', color: DP.ink3 }}>{sub}</div>}
          <div style={{ fontSize: 24, fontWeight: 700, lineHeight: 1.1, marginTop: sub ? 2 : 0, letterSpacing: '-0.02em' }}>{title}</div>
        </div>
      )}
    </div>
  );
}

function DPTabBar({ active }) {
  const tabs = [
    { k: 'home', label: 'Today',    icon: '◐' },
    { k: 'log',  label: 'Log',      icon: '＋' },
    { k: 'prog', label: 'Progress', icon: '◔' },
    { k: 'cal',  label: 'Calendar', icon: '▦' },
    { k: 'you',  label: 'You',      icon: '○' },
  ];
  return (
    <div style={{ borderTop: `1px solid ${DP.border}`, background: DP.bg2, padding: '8px 8px 30px', display: 'flex' }}>
      {tabs.map(t => (
        <div key={t.k} style={{ flex: 1, textAlign: 'center', color: t.k === active ? DP.amber : DP.ink3, position: 'relative' }}>
          {t.k === active && <div style={{ position: 'absolute', top: -8, left: '50%', transform: 'translateX(-50%)', width: 18, height: 2, background: DP.amber, boxShadow: `0 0 4px ${DP.amber}` }} />}
          <div style={{ fontSize: 17 }}>{t.icon}</div>
          <div style={{ fontSize: 10, marginTop: 2, letterSpacing: '0.06em', fontWeight: t.k === active ? 700 : 500, textTransform: 'uppercase' }}>{t.label}</div>
        </div>
      ))}
    </div>
  );
}

function DPScroll({ children }) {
  return <div style={{ flex: 1, overflow: 'auto', padding: '14px 16px 16px' }}>{children}</div>;
}

function DPLabel({ children, color = DP.ink3 }) {
  return <div style={{ fontSize: 10, letterSpacing: '0.14em', textTransform: 'uppercase', color, fontWeight: 600 }}>{children}</div>;
}

window.DarkPerformanceHome = function () {
  return (
    <div style={dpBase}>
      <DPNav leading="Thu · 07.05" trailing="EM" large sub="Welcome back" title="Encall." />
      <DPScroll>
        <div style={{ position: 'relative', background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 20, padding: 18, overflow: 'hidden' }}>
          <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(circle at 80% 20%, ${DP.amber}22, transparent 60%)` }} />
          <div style={{ position: 'relative', display: 'flex', alignItems: 'center', gap: 14 }}>
            <svg viewBox="0 0 80 80" width="86" height="86">
              <circle cx="40" cy="40" r="34" fill="none" stroke={DP.border} strokeWidth="6" />
              <circle cx="40" cy="40" r="34" fill="none" stroke={DP.amber} strokeWidth="6" strokeLinecap="round" strokeDasharray={`${(12/14)*213} 213`} transform="rotate(-90 40 40)" style={{ filter: `drop-shadow(0 0 6px ${DP.amber})` }} />
              <text x="40" y="38" textAnchor="middle" fontSize="22" fontWeight="800" fill={DP.ink}>12</text>
              <text x="40" y="52" textAnchor="middle" fontSize="8" fill={DP.ink3} letterSpacing="2">DAYS</text>
            </svg>
            <div style={{ flex: 1 }}>
              <DPLabel color={DP.amber}>● ON FIRE</DPLabel>
              <div style={{ fontSize: 18, fontWeight: 700, marginTop: 2 }}>12-day streak</div>
              <div style={{ fontSize: 12, color: DP.ink2, marginTop: 2 }}>2 days from your record</div>
              <div style={{ display: 'flex', gap: 3, marginTop: 8 }}>
                {Array.from({ length: 14 }).map((_, i) => (
                  <div key={i} style={{ flex: 1, height: 4, borderRadius: 2, background: i < 12 ? DP.amber : DP.border, boxShadow: i < 12 ? `0 0 4px ${DP.amber}88` : 'none' }} />
                ))}
              </div>
            </div>
          </div>
        </div>

        <div style={{ marginTop: 12, background: DP.amber, color: '#000', borderRadius: 20, padding: 18, display: 'flex', justifyContent: 'space-between', alignItems: 'center', boxShadow: `0 0 20px ${DP.amber}33` }}>
          <div>
            <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.16em' }}>NEXT UP</div>
            <div style={{ fontSize: 22, fontWeight: 800, marginTop: 2 }}>Push Day · A</div>
            <div style={{ fontSize: 11, opacity: 0.7 }}>5 EXERCISES · ~52 MIN</div>
          </div>
          <div style={{ width: 50, height: 50, background: '#000', color: DP.amber, borderRadius: 999, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 20 }}>▶</div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginTop: 12 }}>
          {[
            { l: '7-DAY VOLUME', n: '24.3', u: 't',   c: DP.lime,  spark: [10,15,12,22,28,32,35] },
            { l: 'EST 1RM',      n: '104',  u: 'kg',  c: DP.amber, spark: [4,8,10,12,18,22,28] },
            { l: 'BODYWEIGHT',   n: '78.2', u: 'kg',  c: DP.cyan,  spark: [30,28,26,28,26,24,22] },
            { l: 'SESSIONS',     n: '5',    u: '/wk', c: DP.pink,  spark: [10,18,14,22,18,28,30] },
          ].map((m, i) => (
            <div key={i} style={{ background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 16, padding: 14 }}>
              <DPLabel color={m.c}>{m.l}</DPLabel>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 4, marginTop: 4 }}>
                <div style={{ fontSize: 22, fontWeight: 800, fontVariantNumeric: 'tabular-nums' }}>{m.n}</div>
                <div style={{ fontSize: 11, color: DP.ink3 }}>{m.u}</div>
              </div>
              <svg viewBox="0 0 70 24" style={{ width: '100%', height: 24, marginTop: 4 }}>
                <polyline fill="none" stroke={m.c} strokeWidth="1.5" points={m.spark.map((v, j) => `${j*10},${24-v*0.6}`).join(' ')} />
              </svg>
            </div>
          ))}
        </div>

        <div style={{ marginTop: 16 }}>
          <DPLabel>RECENT</DPLabel>
          {[
            { d: '05.05', t: 'Pull', s: '14 sets · 4.24 t', c: DP.amber },
            { d: '03.05', t: 'Legs', s: '12 sets · 6.11 t', c: DP.cyan  },
            { d: '01.05', t: 'Push', s: '15 sets · 3.98 t', c: DP.pink  },
          ].map((r, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '12px 0', borderBottom: `1px solid ${DP.border}` }}>
              <div style={{ width: 40, fontSize: 11, color: DP.ink3, fontVariantNumeric: 'tabular-nums' }}>{r.d}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{r.t}</div>
                <div style={{ fontSize: 11, color: DP.ink3 }}>{r.s}</div>
              </div>
              <div style={{ color: r.c }}>›</div>
            </div>
          ))}
        </div>
      </DPScroll>
      <DPTabBar active="home" />
    </div>
  );
};

window.DarkPerformanceActive = function () {
  return (
    <div style={dpBase}>
      <DPNav leading="‹ Workout" trailing="34:12" />
      <div style={{ padding: '12px 16px', background: DP.bg2, borderBottom: `1px solid ${DP.border}`, display: 'flex', alignItems: 'center', gap: 12 }}>
        <svg viewBox="0 0 80 80" width="64" height="64">
          <circle cx="40" cy="40" r="34" fill="none" stroke={DP.border} strokeWidth="5" />
          <circle cx="40" cy="40" r="34" fill="none" stroke={DP.amber} strokeWidth="5" strokeLinecap="round" strokeDasharray={`${0.46*213} 213`} transform="rotate(-90 40 40)" style={{ filter: `drop-shadow(0 0 6px ${DP.amber})` }} />
        </svg>
        <div style={{ flex: 1 }}>
          <DPLabel color={DP.amber}>RESTING</DPLabel>
          <div style={{ fontSize: 26, fontWeight: 800, fontVariantNumeric: 'tabular-nums', marginTop: -2 }}>1:24</div>
        </div>
        <div style={{ display: 'flex', gap: 6 }}>
          <div style={{ background: DP.bg, border: `1px solid ${DP.border}`, borderRadius: 999, padding: '6px 12px', fontSize: 11, fontWeight: 600 }}>+15s</div>
          <div style={{ background: DP.bg, border: `1px solid ${DP.border}`, borderRadius: 999, padding: '6px 12px', fontSize: 11, fontWeight: 600 }}>Skip</div>
        </div>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '14px 14px 12px' }}>
        <div style={{ background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 20, padding: 16 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <DPLabel color={DP.amber}>EXERCISE 3 OF 5</DPLabel>
              <div style={{ fontSize: 22, fontWeight: 800, marginTop: 2, letterSpacing: '-0.02em' }}>Bench Press</div>
              <div style={{ fontSize: 11, color: DP.ink3 }}>Barbell · Chest</div>
            </div>
            <div style={{ background: DP.amberDim, color: DP.amber, padding: '4px 10px', borderRadius: 999, fontSize: 10, fontWeight: 700, letterSpacing: '0.1em' }}>+8 KG</div>
          </div>
          <div style={{ marginTop: 12 }}>
            {[
              [1, '60', '10', '3', true],
              [2, '80', '8',  '2', true],
              [3, '85', '6',  '1', true],
              [4, '85', '—',  '—', false],
            ].map(r => (
              <div key={r[0]} style={{ display: 'grid', gridTemplateColumns: '24px 1fr 1fr 1fr 28px', alignItems: 'center', padding: '10px 0', borderBottom: `1px solid ${DP.border}`, fontVariantNumeric: 'tabular-nums' }}>
                <div style={{ fontSize: 11, color: DP.ink3 }}>{r[0]}</div>
                <div style={{ fontSize: 16, fontWeight: 700, color: r[4] ? DP.ink : DP.ink3 }}>{r[1]} <span style={{ fontSize: 11, color: DP.ink3, fontWeight: 500 }}>kg</span></div>
                <div style={{ fontSize: 16, fontWeight: 700, color: r[4] ? DP.ink : DP.ink3 }}>{r[2]}</div>
                <div style={{ fontSize: 12, color: DP.ink3 }}>RIR {r[3]}</div>
                <div style={{ color: r[4] ? DP.lime : DP.amber, textAlign: 'right' }}>{r[4] ? '✓' : '○'}</div>
              </div>
            ))}
          </div>
          <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
            <div style={{ flex: 1, background: DP.amber, color: '#000', padding: '12px 0', borderRadius: 12, textAlign: 'center', fontWeight: 800, fontSize: 13 }}>＋ Add Set</div>
            <div style={{ background: DP.bg2, color: DP.ink, padding: '12px 16px', borderRadius: 12, fontSize: 13, border: `1px solid ${DP.border}`, fontWeight: 600 }}>↻</div>
          </div>
        </div>

        <div style={{ marginTop: 12, background: `linear-gradient(135deg, ${DP.lime}1a, transparent)`, border: `1px solid ${DP.lime}55`, borderRadius: 16, padding: 14 }}>
          <DPLabel color={DP.lime}>● THAT'S GOOD</DPLabel>
          <div style={{ fontSize: 13, marginTop: 4 }}>Volume in line with your 4-week average. Try <span style={{ color: DP.amber, fontWeight: 700 }}>+2.5 kg</span> next session.</div>
        </div>

        <div style={{ marginTop: 14 }}>
          <DPLabel>UP NEXT</DPLabel>
          {['Incline DB Press · 3×10', 'Cable Fly · 3×12', 'Triceps Pushdown · 3×12'].map((x, i) => (
            <div key={i} style={{ padding: '10px 0', borderBottom: `1px solid ${DP.border}`, fontSize: 14, color: DP.ink2 }}>{x}</div>
          ))}
        </div>
      </div>

      <div style={{ display: 'flex', gap: 8, padding: '10px 14px 30px', background: DP.bg2, borderTop: `1px solid ${DP.border}` }}>
        <div style={{ flex: 1, background: DP.pink, color: '#fff', padding: '14px 0', borderRadius: 14, textAlign: 'center', fontWeight: 800, fontSize: 14 }}>Finish</div>
        <div style={{ background: DP.bg, color: DP.ink, padding: '14px 18px', borderRadius: 14, fontWeight: 700, fontSize: 14, border: `1px solid ${DP.border}` }}>Next →</div>
      </div>
    </div>
  );
};

window.DarkPerformanceProgress = function () {
  const points = [40,55,52,60,58,68,72,78,82,88,94,104];
  return (
    <div style={dpBase}>
      <DPNav leading="Progress" trailing="Bench ▾" large sub="Last 12 weeks" title="Performance" />
      <DPScroll>
        <div style={{ background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 20, padding: 18, position: 'relative', overflow: 'hidden' }}>
          <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(ellipse at 100% 0%, ${DP.amber}22, transparent 50%)` }} />
          <div style={{ position: 'relative' }}>
            <DPLabel>EST 1RM</DPLabel>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
              <div style={{ fontSize: 52, fontWeight: 800, letterSpacing: '-0.03em', lineHeight: 0.9 }}>104</div>
              <div style={{ fontSize: 14, color: DP.ink3 }}>kg</div>
              <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 4, color: DP.lime, fontWeight: 700, fontSize: 13 }}>↑ +8 kg</div>
            </div>
            <svg viewBox="0 0 320 110" style={{ width: '100%', height: 110, marginTop: 8 }}>
              <defs>
                <linearGradient id="dp-grad" x1="0" x2="0" y1="0" y2="1">
                  <stop offset="0%" stopColor={DP.amber} stopOpacity="0.6" />
                  <stop offset="100%" stopColor={DP.amber} stopOpacity="0" />
                </linearGradient>
              </defs>
              {[0,1,2,3].map(i => <line key={i} x1="0" x2="320" y1={i*28} y2={i*28} stroke={DP.border} strokeDasharray="2 4" />)}
              <path d={`M${points.map((v, j) => `${j*29},${100 - (v-30)*1.0}`).join(' L')} L${(points.length-1)*29},110 L0,110 Z`} fill="url(#dp-grad)" />
              <path d={`M${points.map((v, j) => `${j*29},${100 - (v-30)*1.0}`).join(' L')}`} fill="none" stroke={DP.amber} strokeWidth="2.5" style={{ filter: `drop-shadow(0 0 4px ${DP.amber})` }} />
              {points.map((v, j) => j === points.length-1 && (
                <circle key={j} cx={j*29} cy={100-(v-30)*1.0} r="4" fill={DP.amber} style={{ filter: `drop-shadow(0 0 6px ${DP.amber})` }} />
              ))}
            </svg>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 6, marginTop: 12 }}>
          {['1M','3M','6M','1Y','ALL'].map((r, i) => (
            <div key={r} style={{ flex: 1, textAlign: 'center', padding: '8px 0', borderRadius: 10, background: i === 1 ? DP.amberDim : DP.card, color: i === 1 ? DP.amber : DP.ink3, fontSize: 11, fontWeight: 700, border: `1px solid ${i === 1 ? DP.amber+'66' : DP.border}` }}>{r}</div>
          ))}
        </div>

        <div style={{ marginTop: 16 }}>
          <DPLabel>PERSONAL BESTS</DPLabel>
          <div style={{ marginTop: 8, background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 16, overflow: 'hidden' }}>
            {[
              ['Bench Press', '95 kg × 5',         DP.amber, true],
              ['Deadlift',    '160 kg × 3',        DP.lime,  true],
              ['Squat',       '130 kg × 6',        DP.cyan,  false],
              ['Pull-up',     'BW + 22.5 × 5',     DP.pink,  true],
            ].map((p, i, arr) => (
              <div key={i} style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12, borderBottom: i < arr.length - 1 ? `1px solid ${DP.border}` : 'none' }}>
                <div style={{ width: 4, height: 28, background: p[2], borderRadius: 2, boxShadow: `0 0 6px ${p[2]}` }} />
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 600 }}>{p[0]}</div>
                  <div style={{ fontSize: 12, color: DP.ink3, fontVariantNumeric: 'tabular-nums' }}>{p[1]}</div>
                </div>
                {p[3] && <div style={{ background: DP.amberDim, color: DP.amber, padding: '4px 10px', borderRadius: 999, fontSize: 10, fontWeight: 700, letterSpacing: '0.1em' }}>★ NEW</div>}
              </div>
            ))}
          </div>
        </div>
      </DPScroll>
      <DPTabBar active="prog" />
    </div>
  );
};

window.DarkPerformanceCalendar = function () {
  const dows = [{k:'mo',l:'M'},{k:'tu',l:'T'},{k:'we',l:'W'},{k:'th',l:'T'},{k:'fr',l:'F'},{k:'sa',l:'S'},{k:'su',l:'S'}];
  return (
    <div style={dpBase}>
      <DPNav leading="‹ ›" trailing="May" large sub="May 2026" title="17 days · 5/wk" />
      <DPScroll>
        <div style={{ background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 20, padding: 16 }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 6, marginBottom: 8 }}>
            {dows.map(d => <div key={d.k} style={{ textAlign: 'center', fontSize: 10, color: DP.ink3, letterSpacing: '0.1em' }}>{d.l}</div>)}
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 6 }}>
            {Array.from({ length: 35 }).map((_, i) => {
              const v = (i*7+3) % 9;
              const has = v >= 4;
              const intensity = v < 4 ? 0 : v < 6 ? 0.35 : v < 8 ? 0.7 : 1;
              const sel = i === 17;
              return (
                <div key={i} style={{ aspectRatio: '1', borderRadius: 8, background: has ? `rgba(255,182,39,${intensity})` : DP.bg2, border: sel ? `1.5px solid ${DP.amber}` : `1px solid ${DP.border}`, color: has && intensity > 0.6 ? '#000' : DP.ink2, fontSize: 11, fontWeight: 600, display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: has && intensity === 1 ? `0 0 6px ${DP.amber}66` : 'none' }}>
                  {(i % 31) + 1}
                </div>
              );
            })}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 12, fontSize: 10, color: DP.ink3, letterSpacing: '0.1em' }}>
            <span>LESS</span>
            {[0,0.35,0.7,1].map((a,i)=> <div key={i} style={{ width: 14, height: 14, borderRadius: 4, background: a===0?DP.bg2:`rgba(255,182,39,${a})`, border: `1px solid ${DP.border}` }} />)}
            <span>MORE</span>
          </div>
        </div>

        <div style={{ marginTop: 12, background: DP.card, border: `1px solid ${DP.border}`, borderRadius: 20, padding: 16 }}>
          <DPLabel color={DP.amber}>● 05.05 · TUESDAY</DPLabel>
          <div style={{ fontSize: 18, fontWeight: 700, marginTop: 4 }}>Pull Day</div>
          <div style={{ fontSize: 12, color: DP.ink3 }}>ChillGym Central · 62 min</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginTop: 12 }}>
            {[['SETS', '14', DP.lime], ['VOLUME', '4.24t', DP.amber], ['MAX', '110kg', DP.cyan]].map((s, i) => (
              <div key={i} style={{ background: DP.bg2, borderRadius: 12, padding: 10, border: `1px solid ${DP.border}` }}>
                <div style={{ fontSize: 9, letterSpacing: '0.14em', color: s[2], fontWeight: 700 }}>{s[0]}</div>
                <div style={{ fontSize: 18, fontWeight: 800, marginTop: 2, fontVariantNumeric: 'tabular-nums' }}>{s[1]}</div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ marginTop: 12, background: `linear-gradient(135deg, ${DP.amber}1a, transparent)`, border: `1px solid ${DP.amber}55`, borderRadius: 16, padding: 14 }}>
          <DPLabel color={DP.amber}>★ NEW PR</DPLabel>
          <div style={{ fontSize: 14, fontWeight: 600, marginTop: 4 }}>Pull-up · BW + 22.5 kg × 5</div>
        </div>
      </DPScroll>
      <DPTabBar active="cal" />
    </div>
  );
};
