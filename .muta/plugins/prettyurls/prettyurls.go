package prettyurls

import (
	"fmt"
	"path/filepath"
	"strings"

	"github.com/leeola/muta"
)

type prettyurls struct {
	lastFile *muta.FileInfo
}

func (s *prettyurls) Prettify(fi *muta.FileInfo) {
	ext := filepath.Ext(fi.Name)
	// If for some reason the file does not have an extension,
	// do nothing
	if ext == "" {
		return
	}

	nonExtName := strings.Replace(fi.Name, ext, "", -1)
	// Ignore index files, since they're already so pretty
	if nonExtName == "index" {
		return
	}

	// Move the file into a directory with it's nonExtName
	fi.Path = filepath.Join(fi.Path, nonExtName)
	// Set the new filename to index.ext
	fi.Name = fmt.Sprintf("index%s", ext)
}

func (s *prettyurls) Name() string {
	return "Prettyurls"
}

func (s *prettyurls) Stream(fi *muta.FileInfo, chunk []byte) (
	*muta.FileInfo, []byte, error) {
	switch {
	case fi == nil:
		return nil, nil, nil

	case filepath.Ext(fi.Name) != ".html":
		return fi, chunk, nil

	case fi != s.lastFile:
		s.lastFile = fi
		s.Prettify(fi)
		return fi, chunk, nil

	default:
		return fi, chunk, nil
	}
}

func Prettyurls() muta.Streamer {
	return &prettyurls{}
}
