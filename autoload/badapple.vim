" read file to create frames
function! s:read_file() abort
    let file = globpath(&rtp, 'resources/badapple.txt')
    let frames = []
    let frame = []

    for line in readfile(file)
        if line !~# "SPLIT"
            call add(frame, line)
        else
            call add(frames, frame)
            let frame = []
        endif
    endfor

    return frames
endfunction:

" play bad apple
function! badapple#play() abort
    let frames = s:read_file()
    " Floating Window
    if exists('*nvim_buf_set_lines()')
      let buf = nvim_create_buf(v:false, v:true)
      let opts = {'relative': 'editor', 'width': 100, 'height': 28,
                  \'row': (&lines - 28) * 0.5, 'col': (&columns - 100) * 0.5, 'style': 'minimal'}
      let win = nvim_open_win(buf, 0, opts)

      for frame in frames
        call nvim_buf_set_lines(buf, 0, -1, v:true, frame)
        redraw!
        sleep 50ms
        let key = getchar(0)
        if key ==# 113
          break
        endif
      endfor

      call nvim_win_close(win, v:true)
    else
        new | setlocal buftype=nofile bufhidden=wipe
        for frame in frames
            call setline(1, frame)
            redraw!
            sleep 50ms
            let key = getchar(0)
            if key ==# 113
                break
            endif
        endfor
        bw!
    endif
endfunction
