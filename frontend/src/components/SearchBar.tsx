import { useEffect, useRef, useState } from "react";
import { api, type SearchResultItem } from "../api";

const TYPE_LABELS: Record<string, string> = {
  producer: "Proizvođač",
  location: "Otkupno mesto",
  fruit: "Voće",
  good: "Roba",
};

interface SearchBarProps {
  onNavigate: (type: string, code: string) => void;
}

export function SearchBar({ onNavigate }: SearchBarProps) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<SearchResultItem[]>([]);
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (query.length < 2) {
      setResults([]);
      return;
    }
    const t = setTimeout(() => {
      api.search(query).then((r) => { setResults(r.results); setOpen(true); }).catch(() => setResults([]));
    }, 250);
    return () => clearTimeout(t);
  }, [query]);

  useEffect(() => {
    function onClick(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    }
    document.addEventListener("mousedown", onClick);
    return () => document.removeEventListener("mousedown", onClick);
  }, []);

  function pick(item: SearchResultItem) {
    onNavigate(item.type, item.code);
    setQuery("");
    setOpen(false);
  }

  return (
    <div className="search-bar" ref={ref}>
      <input
        type="search"
        placeholder="Pretraga proizvođača, mesta, voća..."
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        onFocus={() => results.length > 0 && setOpen(true)}
      />
      {open && results.length > 0 && (
        <ul className="search-results">
          {results.map((r) => (
            <li key={`${r.type}-${r.id}`}>
              <button type="button" onClick={() => pick(r)}>
                <span className="search-type">{TYPE_LABELS[r.type] ?? r.type}</span>
                <strong>{r.name}</strong>
                <span className="search-code">{r.code}</span>
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
