SYSTEM
  stores/STOREHASH/config
  stores/STOREHASH/is_current
  # stores/STOREHASH/snapshot_hash
  connections/HASH/priority
  connections/HASH/idle_DATETIME
  connections/HASH/tmp/
  events/DATETIME_DATAHASH_OPID_TARGETFILEPATHHASH
  events/DATETIME_DATAHASH_OPID_TARGETFILEPATHHASH_SOURCEFILEPATHHASH
  eventsindex/TARGETFILEPATHHASH
  * snapshot/base/STOREHASH_SNAPID_SNAPHASH (snaphash is hash of previous checksum, not last in snapshot batch)
  * snapshot/base/STOREHASH_PREVSNAPID_PREVSNAPHASH
  * snapshot/status/SNAPID_DATETIME_DATAHASH
  * snapshot/status/SNAPID_DATETIME_DATAHASH
  snapshot/items/SNAPID/last_added_eventhash
  snapshot/items/SNAPID/snaphash
  snapshot/items/SNAPID/fullhash (totalsnaphash is hash of events checksum including the last in snapshot batch)
  snapshot/data/dir
  snapshot/data/TARGETFILEPATHHASH_dir1/dir
  snapshot/data/TARGETFILEPATHHASH_dir1/SNAPID_TARGETFILEPATHHASH_filename.filext
  history/invert/DATETIME_TARGETEVENTHASH_OPID_TARGETFILEPATHHASH_SOURCEFILEPATHHASH (targeteventhash != md5 data)


global hashtrack

read a config file

copier(hashheaders) {

  while sleep 1 {

    select hashheaders

    for (h of hashheaders.data) {

      # note: h.key is DATETIME_DATAHASH so it is sortable

      if (!hashtrack[h.key]) hashtrack[h.key] = { stores: {}, info: h.info };

      if (!hashtrack[h.key].stores[h.store] && (hashtrack[h.key].stores[h.store].status < h.value || h.value == 0)) {
        hashtrack[h.key].stores[h.store] = {
          status: h.value
        }
        hashtrack[h.key].grace = new date()

      }

    }

    for (h of hashtrack) {
      if (h.grace + GRACE_TIME > new date()) continue;

      best = max (h.value, h.store.rating)
      if (best < 2) continue;

      for (st of stores)
        if (st !== best)
        if (!h.stores[st] || h.stores[st].value === 0)
        if (!h.is_sync || store.connection.is_lead)
      {
        // copy
        h.stores[st] = {
          status: 1
        }
        startcopy({hash: h, from: best, to: st});

      }

    }


  }

}


freezer(store) {
  setbase(store, max(read '/snapshot/base/'))

  justacounter := 0
  justadate := new date()

  while sleep 1 {

    select ( as a way to wait )

    // check and re-read baseid, if multiple connections exist
    if (store.connection.count > 1)
      if (justacounter++ % 30 == 0 || new date() - justadate > REREAD_BASE_GRACE)
    {
      justadate = new date()

      baseid = max (read '/snapshot/base')

      newbaseid := find new earlier item

      if (newbaseid) {
        setnewbase(store, newbaseid)
        continue
      }
    }

    // find allowance for next item to freeze
    // TODO: to use this allowance, need to aggregate all existing stores and use min (eventhash) from all
    // additionally to min (eventhash) use a time grace, because some stores will be excluded from the
    // above aggregation, if they are "minor" stores. "minor" stores do merging and are not necessarily checked.

    if (store.connection.is_lead) {
      last_contiguous_hash_from_base = null;
      last_it = null;
      distance_count = 0;
      for (it = hashtrack[store.base.fullhash]; *it.value == 2; it++, distance_count++) {
        if (last_it.key == store.snapstatus.key) {
          if (distance_count > COMPACTION_NUM_GRACE && new date() - extractdate(*it.key) > COMPACTION_TIME_GRACE) {
            last_contiguous_hash_from_base = *it;
          }
        }
        last_it = it;
      }

      if (last_contiguous_hash_from_base) freeze(store, last_contiguous_hash_from_base)
    }

    // ...

  }

}


freeze(store, hash) {
  nextid := store.base.id + 1

  out_src_path := src.getremotesourcefile(store, nextid, hash)
  out_target_path := src.getremotetargetfile(store, nextid, hash)

  if (out_src_path && !exist out_src_path) {
    if (!hash.op.deletes_remote_file()) {
      in_path = src.getremotebasefile(store, hash, store.base.id)
      tmp_path = '/connections/' + store.connection.hash + '/tmp/' + tmp_path()
      store.copy(in_path, tmp_path)

      src.apply_remote_event(store, hash, baseid = nextid, tmp_path, out_target_path)

      if (!hash.op.moves_remote_file()) {
        store.move(tmp_path, out_target_path)
      }

    }
  } else {
    src.apply_remote_event(store, hash, baseid = nextid, out_src_path, out_target_path)
  }

  rename_or_create(store,
    file = 'snapshot/status/' + nextid + '_' + hash.key,
    from = 'snapshot/status/' + nextid + '_' + store.snapstatus.key
  );


}


rename_or_create(store, file, from) {
  try {
    store.rename (from, file)
  }
  try {
    store.create (file)
  }
}

setbase(store, baseid) {
  newbaseitem = read '/snapshot/items/' + baseid;
  store.base := newbaseitem

  nextid := store.base.id + 1
  snapstatus = read '/snapshot/status'
  store.snapstatus = max(snapstatus) where snapid = nextid

}

startcopy({hash, from, to}) {
  try {
    buffer = from.read(hash.info.filepath)
  } catch {
    emit to copier([h: hash, value: 0])
    return
  }

  try {
    writeeventfile({store: to, hash.info.filepath, buffer, hash.info.filepathhashes})
    emit to copier([h: hash, value: 2])
    emit to freezer(store)
    return

  } catch {
    emit to copier([h: hash, value: 0])
    return
  }

}

getfilepathhash(string path) {
  return md5(path)
}

writeeventfile({store, eventfilename, buffer, filepathhashes[]) {
  for (f of filepathhashes) {
    h_path = getfilepathhash(f)
    indexfile_path = '/eventsindex/' + h_path;
    if (store.find(indexfile_path)) continue;
    ifpbuffer = f;
    writeatomic({store, indexfile_path, ifpbuffer});
  }
  writeatomic({store, 'events/' + eventfilename, buffer);
}

writeatomic({store, filename, buffer}) {
  tmp_path = '/connections/' + store.connection.hash + '/tmp/' + tmp_path()
  tmp = store.open(tmp_path)
  tmp.write(buffer)
  store.move(tmp_path, eventfilename)
}

parfor(s of stores) {
  connect to s or sleep 30 sec doubling up to 300 sec

  storedata = read all stores



  hashheaders = read all events

  broadcast all hashheaders to copier with value=2 and issync=true






}