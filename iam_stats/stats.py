import os, re

all_c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .,'


def read_ls(dir_name):
    f = os.popen('ls %s' % dir_name)
    ret = []
    for line in f: ret.append(line.strip())
    return ret


def extract_ocr(fname):
    f = open(fname, 'r')
    s = ''
    for line in f:
        if line.strip() == 'OCR:': continue
        if line.strip() == '': continue
        if line.strip() == 'CSR:': break
        s += line.strip() + ' '
    if len(s) == 0: return

    for c in s:
        # if c not in all_c: continue
        if c in letter: letter[c] += 1
        else: letter[c] = 1

    for w in s.split(' '):
        m = re.search('\w+', w.lower())
        if m is None: continue
        else: ww = m.group(0)
        if ww in word: word[ww] += 1
        else: word[ww] = 1


def main():
    global letter, word
    letter = {}; word = {}

    for dir1 in read_ls('ascii'):
        for dir2 in read_ls('ascii/%s' % dir1):
            for fname in read_ls('ascii/%s/%s' % (dir1, dir2)):
                extract_ocr('ascii/%s/%s/%s' % (dir1, dir2, fname))

    count_c = count_w = 0
    list_c = []; list_w = []

    for c in letter:
        list_c.append((c, letter[c]))
        count_c += letter[c]
    sorted_c = reversed(sorted(list_c, key=lambda x: x[1]))
    for item in sorted_c: print('%s, %s' % item)

    print('--------')

    for w in word:
        list_w.append((w, word[w]))
        count_w += word[w]
    sorted_w = reversed(sorted(list_w, key=lambda x: x[1]))
    for item in sorted_w: print('%s, %s' % item)

    print('--------')

    print('total characters: %d' % count_c)
    print('total words: %d' % count_w)


if __name__ == '__main__': main()
