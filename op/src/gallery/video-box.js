import { makeStyles } from '@material-ui/core';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import { videourl } from './gallery-context';
import Close from '@material-ui/icons/Close';
import { useSwipeable } from 'react-swipeable';


const useStyles = makeStyles((theme) => ({
    videoBox: {
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        zIndex: 1000,
    },
    vidLayer: {
        width: '100%',
        height: '100%',
        position: 'absolute',
    },
    vidBack: {
        objectFit: 'cover',
        zIndex: 1000,
    },
    vidBackMid: {
        backgroundColor: '#000b',
        zIndex: 1001
    },
    vidFront: {
        objectFit: 'contain',
        zIndex: 1010,
    },
    closeButton: {
        color: 'white',
        zIndex: '1000000',
        position: 'absolute',
        right: 0,
        top: 0,
        padding: theme.spacing(2),
        width: '2em',
        '&:hover': {
            color: '#888'
        }
    }
}));

export const VideoBox = ({ id, onClose, onNext, onPrev, onUp, onDown }) => {
    const classes = useStyles();
    const [doDisplay, setDoDisplay] = useState(false);
    const [videoUrl, setVideoUrl] = useState(null);
    const [isVideoLoaded, setIsVideoLoaded] = useState(false);

    const boxElement = useRef(null);

    const videoCompleteCallback = function(e) {
        onNext({}, id)
    }

    const handleClosure = useCallback(e => {
        setDoDisplay(false)
        setVideoUrl(null)
        onClose && onClose(e)
    }, [onClose])

    useEffect(() => {
        setIsVideoLoaded(false)
        console.log('Video Url : ' + videourl(id))
        if (id) {
            setDoDisplay(true)
            setVideoUrl(videourl(id))
            setTimeout(() => {
                boxElement?.current?.focus()
            }, 0)
        } else {
            setDoDisplay(false)
        }
    }, [id, handleClosure, boxElement]);

    const swipeHandlers = useSwipeable({
        onSwipedLeft: e => onNext && onNext(e, id),
        onSwipedRight: e => onPrev && onPrev(e, id),
        onSwipeUp: e => onPrev && onUp(e, id),
        onSwipedDown: e => onPrev && onDown(e, id),
    })

    return <>
        <div className={classes.videoBox}
            style={{
                display: doDisplay ? 'block' : 'none',
                backgroundColor: isVideoLoaded ? '#333c' : '#3330'
            }}
            onKeyDown={e => {
                switch (e.code) {
                    case 'ArrowLeft':
                        onNext && onPrev(e, id)
                        e.preventDefault()
                        return
                    case 'ArrowRight':
                        onNext && onNext(e, id)
                        e.preventDefault()
                        return
                    case 'Escape':
                        handleClosure(e)
                        e.preventDefault()
                        return
                    default:
                        return
                }
            }}
            {...swipeHandlers} >
            <Close className={classes.closeButton} onClick={handleClosure} />
            {id && <div key={id} style={{ opacity: isVideoLoaded ? 1 : 0.5 }}>
                <video className={`${classes.vidLayer} ${classes.vidFront}`}
                    autoPlay={true} 
                    controls style={{ backgroundImage: `${videoUrl}` }}
                    onLoadedData={e => setIsVideoLoaded(true)}
                    onEnded={videoCompleteCallback}
                    ref={boxElement}
                >
                    <source src={videoUrl} type="video/mp4" ></source>
                </video>
                <div className={`${classes.vidLayer} ${classes.vidBackMid}`}></div>
                <video className={`${classes.vidLayer} ${classes.vidBack}`}
                    autoPlay={true} loop={true} muted={true}>
                    <source src={videoUrl} type="video/mp4"></source>
                </video>
            </div>}
        </div>
    </>
}