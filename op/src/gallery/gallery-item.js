import { makeStyles, Paper } from '@material-ui/core';
import { LazyLoadComponent } from 'react-lazy-load-image-component';
import React from 'react';

const useStyles = makeStyles((theme) => ({
    galleryItemHolder: {
        position: 'relative',
        backgroundColor: '#222',
        overflow: 'visible',
    },
    galleryItem: {
        position: 'absolute',
        backgroundSize: 'cover',
        backgroundPosition: 'top',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        '&:hover': {
            backgroundColor: '#717171',
            top: '-10%',
            left: '-10%',
            right: '-10%',
            bottom: '-10%',
            zIndex: 1000,
            borderRadius: '5px',
        },
        '&:not(:focus):hover': {
            zIndex: 1,
        }
    }
}));

export const GalleryItem = ({ id, frameUrl, onItemClick, width, height, onHoverCallback }) => {
    const classes = useStyles();
    return <>
        <LazyLoadComponent>
            <Paper className={classes.galleryItemHolder} 
                    style={{width: `${width}px`, height: `${height}px`}}
                    onMouseEnter={onHoverCallback}
                >
                <div className={classes.galleryItem}
                    style={{ backgroundImage: `url(${frameUrl})` }}
                    onClick={onItemClick}
                    data-id={id}
                >
                </div>
            </Paper>
        </LazyLoadComponent>
    </>
}