local ls = require 'luasnip'
local s = ls.s
local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
local c = ls.c
local d = ls.d
local fmt = require("luasnip.extras.fmt").fmt

local snip = {}



local graph = s("graph", fmt([[
/** @brief コスト付きの有向辺 */
template <class T>
struct Edge
{{
    int from;
    int to;
    T val;

	Edge() : from(-1), to(-1), val(T()) {{}}
	Edge(const int& i) : from(-1), to(i), val(T()) {{}} 
	Edge(int from, int to) : from(from), to(to), val(T()) {{}}
	Edge(int from, int to, T val) : from(from), to(to), val(val) {{}}
	bool operator==(const Edge &e) const {{ return from == e.from && to == e.to && val == e.val; }}
	bool operator!=(const Edge &e) const {{ return from != e.from || to != e.to || val != e.val; }}
	bool operator<(const Edge &e) const {{ return val < e.val; }}
	bool operator>(const Edge &e) const {{ return val > e.val; }}
	bool operator<=(const Edge &e) const {{ return val <= e.val; }}
	bool operator>=(const Edge &e) const {{ return val >= e.val; }}

	operator int() const {{ return to; }}

	friend ostream& operator << (ostream& os, const Edge& e) {{
		os << e.from << " -> " << e.to << " : " << e.val;
		return os;
	}}
}};
template <class T> using Graph = vector<vector<Edge<T>>>;

/** @brief 有向グラフの辺を反転する */
template <class T>
vector<vector<T>> inverseGraph(const vector<vector<T>>& G) {{
	vector<vector<T>> rG(G.size());
	rep(i, G.size()) for (const T& e : G[i]) rG[e].push_back(i);
	return rG;
}}
/** @brief 有向グラフの辺を反転する */
template <class T>
vector<vector<Edge<T>>> inverseGraph(const vector<vector<Edge<T>>>& G) {{
	vector<vector<Edge<T>>> rG(G.size());
	rep(i, G.size()) for (const Edge<T>& e : G[i]) rG[e.to].push_back(Edge<T>(e.to, e.from, e.val));
	return rG;
}}
]],
	{}
))
table.insert(snip, graph)

local bfs = s("bfs", fmt([[
vll dist({n}, INF);
queue<int> q;
q.push({start});
dist[{start}] = 0;

while (!q.empty()) {{
	ll now = q.front();
	q.pop();

	{visit}

	for (const int& next : {graph}[now]) {{
		if (dist[next] != INF) continue;
		dist[next] = dist[now] + 1;
		q.push(next);

		{found}
	}}
}}
]],
	{
		n = i(1, "n"),
		start = i(2, "s"),
		visit = i(3, "// On visit"),
		graph = i(4, "graph"),
		found = i(5, "// On found")
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, bfs)

local bfs_grid = s("bfs_grid", fmt([[
vector<vector<ll>> dist({h}, vector<ll>({w}, INF));
queue<P> q;
q.push({start});
dist[q.front().first][q.front().second] = 0;

while(!q.empty()) {{
	auto [y, x] = q.front();
	q.pop();

	{visit}{}

	rep(i, 4) {{
		int nx = x + dx[i];
		int ny = y + dy[i];
		if (nx < 0 || {w} <= nx || ny < 0 || {h} <= ny) continue;
		if (dist[ny][nx] != INF) continue;
		dist[ny][nx] = dist[y][x] + 1;
		q.push({{ny, nx}});

		{found}
	}}
}}
]],
	{
		h = i(1, "h"),
		w = i(2, "w"),
		start = i(3, "s"),
		visit = i(4, "// On visit"),
		found = i(5, "// On found"),
		i(0)
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, bfs_grid)

local dijkstra = s("dijkstra", fmt([[
struct DijkstraResult {{
	vector<ll> dist;
	vector<int> prev;

	DijkstraResult(const vector<ll>& dist, const vector<int>& prev) : dist(dist), prev(prev) {{}}

	ll operator[](const int i) const {{ return dist[i]; }}
	operator size_t() const {{ return dist.size(); }}

	/**
	 * @brief スタート地点からgoalまでの経路を復元する O(E)
	 * @param goal 経路復元したいノード 
	 * @return vector<long long> スタート地点からgoalまでの経路
	*/
	vector<int> restore(const int goal) const {{
		vector<int> path;
		for (int now = goal; now != -1; now = prev[now]) path.push_back(now);
		reverse(path.begin(), path.end());
		return path;
	}}
}};

/**
 * @brief グラフの最短経路を求める O(|E| log |V|)
 * @remark コストに負の値があるときは使えない
 * @remark 全ての辺がコスト1の場合はBFSで求まる
 * @param G 隣接リスト
 * @param start スタート地点のノード番号
 * @return DijkstraGridResult dist[x] にスタート地点からxまでの最短距離が格納される @n restore(long long goal)で経路復元できる
*/
template <class T>
DijkstraResult dijkstra(const vector<vector<Edge<T>>> &G, const int start, const T inf) {{
	vector<T> dist(G.size(), inf);
	vector<int> prev(G.size(), -1);
	priority_queue<PLL, vector<PLL>, greater<PLL>> q;
	q.push({{0, start}});
	dist[start] = 0;

	while (!q.empty()) {{
		auto [nowCost, now] = q.top();
		q.pop();
		if (dist[now] < nowCost) continue;

		{visit}{}

		for (const Edge<T>& e : G[now]) {{
			if (dist[e.to] <= dist[now] + e.val) continue;
			dist[e.to] = dist[now] + e.val;
			prev[e.to] = now;
			q.push({{dist[e.to], e.to}});

			{found}
		}}
	}}

	return DijkstraResult(dist, prev);
}}
]],
	{
		visit = i(1, "// On visit"),
		found = i(2, "// On found"),
		i(0)
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, dijkstra)

local dijkstra_grid = s("dijkstra_grid", fmt([[
struct DijkstraGridResult {{
	vector<vector<ll>> dist;
	vector<vector<P>> prev;

	DijkstraGridResult(const vector<vector<ll>>& dist, const vector<vector<P>>& prev) : dist(dist), prev(prev) {{}}

	vector<ll> operator[](const int i) const {{ return dist[i]; }}
	operator size_t() const {{ return dist.size(); }}

	/**
	 * @brief スタート地点からgoalまでの経路を復元する O(4HW)
	 * @param goal 経路復元したい座標 
	 * @return vector<pair<int, int>> スタート地点からgoalまでの経路
	*/
	vector<P> restore(const P goal) const {{
		vector<P> path;
		for (P now = goal; now != P(-1, -1); now = prev[now.first][now.second]) path.push_back(now);
		reverse(path.begin(), path.end());
		return path;
	}}
}};

/**
 * @brief グリッド上の最短経路を求める O(4HW log(HW))
 * @remark コストに負の値があるときは使えない
 * @remark 最大1000*1000のグリッドでO(2 * 10^7)程度
 * @param grid 隣のマスからのコストが格納されたグリッド
 * @param sy スタート地点のy座標
 * @param sx スタート地点のx座標
 * @return dist[y][x] にスタート地点から(y, x)までの最短距離が格納される @n restore(pair<int, int> goal)で経路復元できる
*/
DijkstraGridResult dijkstra(const vector<vector<ll>> &grid, int sy, int sx) {{
	vector<vector<ll>> dist(grid.size(), vector<ll>(grid[0].size(), INF));
	vector<vector<P>> prev(grid.size(), vector<P>(grid[0].size(), P(-1, -1)));
	priority_queue<PPLL, vector<PPLL>, greater<PPLL>> q;
	q.push({{0, {{sy, sx}}}});
	dist[sy][sx] = 0;

	while (!q.empty()) {{
		auto [nowCost, pos] = q.top();
		auto [y, x] = pos;
		q.pop();
		if (dist[y][x] < nowCost) continue;

		{visit}{}

		rep(i, 4) {{
			ll nx = x + dx[i];
			ll ny = y + dy[i];
			if (nx < 0 || grid[0].size() <= nx || ny < 0 || grid.size() <= ny) continue;
			if (dist[ny][nx] <= nowCost + grid[ny][nx]) continue;
			dist[ny][nx] = nowCost + grid[ny][nx];
			prev[ny][nx] = pos;
			q.push({{dist[ny][nx], {{ny, nx}}}});

			{found}
		}}
	}}

	return DijkstraGridResult(dist, prev);
}}
]],
	{
		visit = i(1, "// On visit"),
		found = i(2, "// On found"),
		i(0)
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, dijkstra_grid)

local warshall_floyd = s("warshall_floyd", fmt([[
for (int k = 0; k < {n}; k++){{ // 経由する頂点
	for (int i = 0; i < {n}; i++) {{ // 始点
		for (int j = 0; j < {n}; j++) {{ // 終点
			{d}[i][j] = min({d}[i][j], {d}[i][k] + {d}[k][j]);
		}}
	}}
}}
]],
	{
		n = i(1, "n"),
		d = i(2, "d")
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, warshall_floyd)

local topological_sort = s("topological_sort", fmt([[
/**
* @brief トポロジカルソートO(V + E)
* @details 有向グラフの依存関係を考慮したソート
* @attention グラフが有向非巡回グラフ(DAG)の場合のみ使用可能
* @remark queueをpriority_queueに変えると、辞書順最小/最大のトポロジカルソートが得られる
* @remark 特定の頂点への最短経路を求める場合は、向きを反転したグラフに、その頂点から帰りがけ順にDFSをする
* @param graph 隣接リスト
* @return トポロジカルソートされた頂点番号 (閉路があった場合は空のvectorを返す)
*/
template <class T>
vector<int> topologicalSort(const vector<vector<T>>& graph) {{
	vector<int> result;
	vector<int> in(graph.size(), 0);

	for(const auto& v : graph) {{
		for(const int& to : v) {{
			in[to]++;
		}}
	}}

	queue<int> q;
	for (int i = 0; i < in.size(); ++i) {{
		if (in[i] == 0) q.push(i);
	}}

	while (!q.empty()) {{
		int v = q.front(); q.pop();
		result.push_back(v);

		for (const int& to : graph[v]) {{
			if (--in[to] == 0) q.push(to);
		}}
	}}

	return result.size() == graph.size() ? result : vector<int>();
}}
]],
	{}
))
table.insert(snip, topological_sort)

local euler_tour = s("euler_tour", fmt([[
/**
* @brief オイラーツアー O(V+E)
* @attention 木であること
* @attention 無向グラフ、または根から全ての頂点を回れること
* @param g 隣接リスト
* @param root 開始する頂点番号
* @return 各頂点の部分木の始まりを表すvectorと、部分木の終わりを表すvectorのペア
*/
pair<vector<long long>, vector<long long>> euler_tour(const vector<vector<long long>> g, const int root = 0) {{
	vector<long long> start(n, 0); // 新たな頂点番号&区間の始まり
	vector<long long> end(n, 0); // 自分以下の部分木の終わり(半開区間)
	auto dfs = [&](auto self, int v, int p, int idx) -> int {{
		start[v] = idx;

		int last = idx;
		for (ll to : g[v]) {{
			if (to == p) continue;
			last = self(self, to, v, last + 1);
		}}
		end[v] = last + 1;
		return last;
	}};
	dfs(dfs, root, -1, 0);
	
	return {{start, end}};
}}
]],
	{}
))
table.insert(snip, euler_tour)

local union_find = s("union_find", fmt([[
/** @brief UnionFind木(Disjoint Set Union) */
class UnionFind
{{
  private:
    ll _size;
    vector<ll> _parent;

  public:
	/** @brief UnionFind木を初期化
	 * @param size 頂点数
	 */
    UnionFind(ll size) {{
        _size = size;
        _parent.resize(_size, -1);
    }}

	/** @brief 頂点xが属するグループの値を求める O(償却1) */
    ll root(ll x) {{
        if (_parent[x] < 0) return x;
        else return _parent[x] = root(_parent[x]);
    }}

	/** @brief 頂点xと頂点yを同じグループにする O(償却1) */
    void unite(ll x, ll y) {{
        x = root(x);
        y = root(y);
        if (x != y) {{
            if (-_parent[x] < -_parent[y]) swap(x, y);
            _parent[x] += _parent[y];
            _parent[y] = x;
        }}
    }}

	/** @brief xとyが同じグループに属するかを判定 O(償却1) */
    bool is_same(ll x, ll y) {{ return root(x) == root(y); }}

	/** @brief 頂点xが属するグループのサイズを求める O(償却1) */
    ll size(ll x) {{ return -_parent[root(x)]; }}

	/** @brief すべてのグループを列挙 O(n) */
    vector<vector<ll>> groups() {{
        vector<vector<ll>> member(_size);
        for (ll i = 0; i < _size; ++i) {{
            member[root(i)].push_back(i);
        }}

        vector<vector<ll>> result;
        for (ll i = 0; i < _size; ++i) {{
            if (!member[i].empty()) result.push_back(member[i]);
        }}

        return result;
    }}
}};
]],
	{}
))
table.insert(snip, union_find)



local cycle_detection = s("cycle_detection", fmt([[
/** 
* @brief グラフのサイクル検出 O(V + E)
* @param G 隣接リスト(Edge<T>にfromを設定する必要がある)
* @param directional 逆流を許すか(無向グラフの場合はfalse)
* @param all 全ての頂点から探索を開始するか
* @param start 探索を開始する頂点
* @return 最初に見つけたサイクルの辺のリスト
*/
template <class T>
vector<Edge<T>> detect_cycle(const Graph<T> &G, const bool directional = true, const bool all = true, const int start = 0) {{
	vector<bool> seen(G.size(), false), finished(G.size(), false);
	stack<Edge<T>> history;

	auto dfs = [&](const auto dfs, const int v, const Edge<T> e) -> int {{
		seen[v] = true; // たどり着いた
		history.push(e);
		
		for(const Edge<T> next : G[v]) {{
			// 無向グラフの場合、逆流を禁止する
			if (!directional && next.to == e.from) continue;
			if (finished[next.to]) continue;
			// １回たどり着いた頂点に再度たどり着いた場合、サイクルが検出される
			if (seen[next.to] && !finished[next.to]) {{
				history.push(next);
				return next.to;
			}}

			int pos = dfs(dfs, next.to, next);
			if (pos != -1) return pos;
		}}

		finished[v] = true; // 完全に見終わった
		history.pop();
		return -1;
	}};

	auto restore = [&](const int pos) -> vector<Edge<T>> {{
		vector<Edge<T>> cycle;
		// 履歴を、同じ頂点まで遡る
		while (!history.empty()) {{
			const Edge<T> e = history.top();
			cycle.push_back(e);
			history.pop();
			if (e.from == pos) break;
		}}
		reverse(cycle.begin(), cycle.end());
		return cycle;
	}};

	// start から探索を開始
	int pos = -1;
	pos = dfs(dfs, start, Edge<T>());
	if (pos != -1) return restore(pos);

	// all が true の場合、全ての頂点から探索を開始
	if (all) {{
		for (int v = 0; v < (int)G.size(); ++v) {{
			if (seen[v]) continue;
			history = stack<Edge<T>>();
			pos = dfs(dfs, v, Edge<T>());
			if (pos != -1) return restore(pos);
		}}
	}}

	// サイクルが見つからなかった場合
	return vector<Edge<T>>();
}}
]],
	{}
))
table.insert(snip, cycle_detection)

local scc = s("scc", fmt([[
/**
 * @brief 強連結成分分解(Strongly Connected Components)
 * @details 強連結成分を1つのノードとして扱うグラフを再構築する
 * @attention グラフが有向非巡回グラフ(DAG)である必要がある
 * @note 新たなグラフはトポロジカル順になる
 */
struct SCC
{{
  private:
    // 元の頂点数
    long long n;
    // G: 元のグラフ, rG: 逆辺を張ったグラフ
    vector<vector<long long>> G, rG;

    // order: トポロジカルソート
    vector<long long> order;

	// component: 各頂点が属する強連結成分の番号
    vector<long long> component;
	// component_size: 強連結成分のサイズ
    vector<long long> components_size;
	// component_count: 強連結成分の数
	long long component_count = 0;
	// component_elements: 各強連結成分に属する頂点のリスト
	vector<vector<long long>> component_elements;

	vector<vector<long long>> rebuildedG;

	// 1度目のDFSでトポロジカルソートを行う O(|V|+|E|)
    void topological_sort() {{
        vector<bool> used(n, false);
        auto dfs = [&used, this](auto dfs, long long v) -> void {{
            used[v] = 1;
            for (auto nv : G[v]) {{
                if (!used[nv]) dfs(dfs, nv);
            }}
            order.push_back(v);
        }};

        for (long long v = 0; v < n; ++v) {{
            if (!used[v]) dfs(dfs, v);
        }}

        reverse(order.begin(), order.end());
    }}
	// 2度目のDFSで逆辺のグラフでトポロジカル順に強連結成分を探す O(|V|+|E|)
    void search_components() {{
        auto dfs = [this](auto dfs, long long v, long long k) -> void {{
            component[v] = k;
            components_size[k]++;
			component_elements[k].push_back(v);
            for (auto nv : rG[v]) {{
                if (component[nv] == -1) dfs(dfs, nv, k);
            }}
        }};

		for (auto v : order) {{
			if (component[v] == -1) {{
				components_size.push_back(0);
				component_elements.push_back(vector<long long>());
				dfs(dfs, v, component_count++);
			}}
		}}
    }}
	/**
	* @brief 強連結成分を1つのノードとして扱うグラフを再構築する O(|V|+|E|)
	*/
    void rebuild() {{
		rebuildedG.resize(component_count);

        set<pair<long long, long long>> connected;
        for (long long v = 0; v < n; v++) {{
            for (auto nv : G[v]) {{
				long long v_comp = component[v];
				long long nv_comp = component[nv];
				pair<long long, long long> p = {{v_comp, nv_comp}};
                if (!is_same(v, nv) &&
                    !connected.count(p)) {{
                    rebuildedG[v_comp].push_back(nv_comp);
					connected.insert(p);
                }}
            }}
        }}
    }}

  public:
	/**
	 * @brief 強連結成分分解を行う O(3 * |V|+|E|)
	 * @details 強連結成分を1つのノードとして扱うグラフを再構築する
	 * @attention グラフが有効非巡回グラフ(DAG)である必要がある
	 */
    SCC(vector<vector<long long>> &_G) : n(_G.size()), G(_G), rG(vector<vector<long long>>(n)), component(vector<long long>(n, -1)) {{
        // 逆辺を張ったグラフを作成
        for (long long v = 0; v < n; v++) {{
            for (auto nv : G[v])
                rG[nv].push_back(v);
        }}

        topological_sort();
		search_components();
		rebuild();
    }}

	/**
	 * @brief 強連結成分の数(新たなグラフのノード数)を取得する
	 */
	size_t size() const {{ return component_count; }}
	/**
	 * @brief 元の頂点vが属する強連結成分の番号(新たな頂点番号)を取得する
	 * @param v 頂点の番号
	 */
	long long get_component(long long v) const {{
		assert(0 <= v && v < n);
		return component[v];
	}}
	/**
	 * @brief 強連結成分のサイズを取得する
	 * @param component 強連結成分の番号
	 */
	long long get_component_size(long long component) const {{
		assert(0 <= component && component < size());
		return components_size[component];
	}}
	/**
	 * @brief 強連結成分に属する頂点のリストを取得する
	 * @param component 強連結成分の番号
	 */
	vector<long long> get_component_elements(long long component) const {{
		assert(0 <= component && component < size());
		return component_elements[component];
	}}

	/**
	 * @brief 新たなグラフのcomponentから伸びている先のリストを取得する
	 * @details あたかもSCCのインスタンスを隣接リストのように扱える
	 * @note トポロジカル順に並んでいる
	 * @attention 戻り値は参照なので破壊的変更に注意
	 * @param component 強連結成分の番号
	 */
	vector<long long>& operator[](long long component) {{
		assert(0 <= component && component < size());
		return rebuildedG[component];
	}}
	/**
	 * @brief 暗黙的なstd::vector<std::vector<long long>>への変換
	 */
	operator vector<vector<long long>>() const {{ return rebuildedG; }}

	/**
	* @brief 2頂点が同じ強連結成分に属するかを判定する
	*/
    bool is_same(long long u, long long v) {{ return component[u] == component[v]; }}
}};
]],
	{}
))
table.insert(snip, scc)

return snip
