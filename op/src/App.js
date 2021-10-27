import AppBar from '@material-ui/core/AppBar';
import IconButton from '@material-ui/core/IconButton';
import { makeStyles } from '@material-ui/core/styles';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import { ZoomIn, ZoomOut } from '@material-ui/icons';
import MenuIcon from '@material-ui/icons/Menu';
import React, { useContext, useEffect, useState } from 'react';
import './App.css';
import { createNewGalleryContext, GalleryContext } from './gallery/gallery-context';
import { GalleryItem } from './gallery/gallery-item';
import { VideoBox } from './gallery/video-box';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
  },
  menuButton: {
    marginRight: theme.spacing(2),
  },
  title: {
    flexGrow: 1,
  },
  galleryBox: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    flexWrap: 'wrap',
    padding: '10px 0',
    backgroundColor: '#333',
    '& > *': {
      margin: theme.spacing(0.25),
      minWidth: theme.spacing(5),
      minHeight: theme.spacing(8),
    },
  },
  videoBox: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  }
}));
const initialGalleryContext = createNewGalleryContext();
            
const App = () => {
  const [galleryItemWidth, setGalleryItemWidth] = useState(150);
  const getProportionalHeight = (width) => parseInt(width * 7 / 4);
  const [galleryItemHeight, setGalleryItemHeight] = useState(getProportionalHeight(galleryItemWidth));
  const classes = useStyles();
  return (
    <GalleryContext.Provider value={initialGalleryContext}>
      <AppBar position="static">
        <Toolbar>
          <IconButton edge="start" className={classes.menuButton} color="inherit" aria-label="menu">
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" className={classes.title}>
            Gallery
          </Typography>
          <IconButton color="inherit" onClick={e => {
            if (galleryItemWidth > 400) return;
            const newWidth = galleryItemWidth + 50
            setGalleryItemWidth(newWidth)
            setGalleryItemHeight(getProportionalHeight(newWidth))
          }}><ZoomIn /></IconButton>
          <IconButton color="inherit" onClick={e => {
            if (galleryItemWidth < 100) return;
            const newWidth = galleryItemWidth - 50
            setGalleryItemWidth(newWidth)
            setGalleryItemHeight(getProportionalHeight(newWidth))
          }}><ZoomOut /></IconButton>
        </Toolbar>
      </AppBar>
      <Gallery galleryItemWidth={galleryItemWidth} galleryItemHeight={galleryItemHeight} />
    </GalleryContext.Provider>
  );
}

export const Gallery = ({galleryItemWidth, galleryItemHeight}) => {
  const classes = useStyles();
  const galleryContext = useContext(GalleryContext);
  const [dataList, setDataList] = useState(galleryContext.dataList);
  const [idSelectedToPlay, setIdSelectedToPlay] = useState(null);
  const [hoveringGalleryItem, setHoveringGalleryItem] = useState(null);
  useEffect(() => {
    function init() {
      console.log('initializing...')
      if (galleryContext && galleryContext.dataList && galleryContext.dataList.length > 0) {
        galleryContext.dataList && setDataList([...galleryContext.dataList.sort((a, b) => {
          console.log(a)
          return 0
        })]);
      } else {
        setTimeout(init, 20)
      }
    }
    init()
  }, [galleryContext, galleryContext.dataList, setDataList]);

  const onItemClick = (e) => {
    setIdSelectedToPlay(e.target.dataset.id);
  }

  const onVideoNext = (e, id) => {
    const index = dataList.findIndex(d => d.id === id )
    if (index >= 0 && index < dataList.length - 1) {
      setIdSelectedToPlay(dataList[index + 1].id);
    }
  }

  const onVideoPrev = (e, id) => {
    const index = dataList.findIndex(d => d.id === id )
    if (index > 0) {
      setIdSelectedToPlay(dataList[index - 1].id);
    }
  }
  
  const showGalleryItemData = (data) => {
    if (data) {
      setHoveringGalleryItem(data)
    }
  }

  return <>
    <VideoBox id={idSelectedToPlay} onClose={e => setIdSelectedToPlay(null)} 
      onNext={onVideoNext} onPrev={onVideoPrev}
    />
    <div className={classes.galleryBox}>
      {dataList && dataList.map(d =>
        <GalleryItem 
          key={d.data} id={d.id} 
          frameUrl={d.frameUrl} 
          onItemClick={onItemClick}
          onHoverCallback={() => showGalleryItemData(d)}
          width={galleryItemWidth}
          height={galleryItemHeight}
        />
      )}
    </div>
    {!idSelectedToPlay &&
      hoveringGalleryItem && 
      <div style={{
          position: "fixed",
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: "white",
          zIndex: 100000,
          padding: 5,
          textAlign: "center"
        }} >{hoveringGalleryItem.userId}</div>
    }
  </>
}


export default App;
