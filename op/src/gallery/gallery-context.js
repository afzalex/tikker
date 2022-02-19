import React from "react";
import { from } from "rxjs";
import { map, mergeMap } from "rxjs/operators";

const SERVE_URL = 'http://localhost:8000';
// const SERVE_URL = '';
// const SERVE_URL=process.env.SERVE_URL;

const downloadListUrl = `assets/downloadlist.json`;
export const createNewGalleryContext = () => {
    const context = {
        dataList: []
    };
    from(fetch(downloadListUrl).then(d => d.text()))
    .pipe(
      mergeMap(d => from(d.split("\n"))),
      map(d => {
        const regex = /((.*?)_(\d+)_(\d+))\.mp4/.exec(d);
        if (regex == null) {
            return {
                data: d,
                id: 'na',
                userId: 'na',
                frameUrl: 'https://image.freepik.com/free-vector/404-error-page-found_24908-59517.jpg',
                date: 'na'
            }
        }
        const id = regex[1];
        return {
          data: d,
          id: id,
          userId: regex[2],
          frameUrl: frameurl(id),
          date: regex[3]
        };
      }),
    ).subscribe(d => {
        context.dataList = [...context.dataList, d];
    });
    return context;
}

export const GalleryContext = React.createContext({
    dataList: [],
});



console.log(process.env.SERVE_URL)

export const videourl = (id) => {
    return `${SERVE_URL}/output/general/downloads/${id}.mp4`;
}

export const frameurl = (id, n) => {
    return `${SERVE_URL}/output/general/frames/at500/${id}.mp4_frame0${n?n:3}.jpeg`;
}

export const frameurls = (id) => {

}

export const jsonurl = (id) => {
    return ''
}

