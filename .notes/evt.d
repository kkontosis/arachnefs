module evt;

import std.typecons;

// import tagged_union;

enum EvtOp {
  // Create = 'C',
  Append = 'A',
  Delete = 'D'
};

alias FilePathType = string;
alias EvtTimestampType = string;
alias EvtRandomIdType = string;
alias EvtOffsetType = long;
alias EvtSizeType = long;
alias EvtChecksumType = string;

//alias DataType = immutable(char)[];

struct EvtHeaderCommon {
  FilePathType file_path;
  EvtTimestampType evt_timestamp;
  EvtRandomIdType evt_random_id;
  EvtOffsetType evt_offset;
  EvtSizeType evt_size;
  EvtChecksumType evt_checksum;
};

struct AppendEvt {
  alias op = EvtOp.Append;
  alias hdr_com = hdr;
  // @property EvtOp op() pure const { return EvtOp.Append; }

  EvtHeaderCommon hdr;
  //EvtData data;

  unittest {
    AppendEvt ev;
    assert(ev.op == EvtOp.Append);
  }
};

struct DeleteEvt {
  alias op = EvtOp.Delete;
  alias hdr_com = hdr;

  EvtHeaderCommon hdr;
  //EvtData data;

};

private pure EvtOp get_op(T)(T evt_body) { return evt_body.op; }
pure EvtHeaderCommon get_hdr_com(T)(T evt_body) { return evt_body.hdr_com; }

struct Evt {

  private:
    union {
      AppendEvt append_evt;
      DeleteEvt delete_evt;
    };

    EvtOp op_tag;

  public:
    this(AppendEvt rhs) {
      op_tag = rhs.op;
      this.append_evt = rhs;
    }

    this(DeleteEvt rhs) {
      op_tag = rhs.op;
      this.delete_evt = rhs;
    }

    auto ref apply(alias fun)() {
      final switch(op_tag) with(EvtOp) {
        case Append:
          return fun(append_evt);

        case Delete:
          return fun(delete_evt);
      }
    }

  unittest {

    AppendEvt append_evt;
    Evt evt = append_evt;

    assert(evt.op_tag == EvtOp.Append);
    assert(evt.apply!get_op() == EvtOp.Append);
    EvtHeaderCommon hdr_com = evt.apply!get_hdr_com();


  }

};

pure auto spatial_less_extract(Evt a) {
  auto hdr_a = a.apply!get_hdr_com();
  auto tpl_a = tuple(hdr_a.file_path, hdr_a.evt_offset);
  return tpl_a;
};

pure bool spatial_less(Evt a, Evt b) {
  auto op_a = spatial_less_extract(a);
  auto op_b = spatial_less_extract(b);
  return op_a < op_b;
}

unittest {
  immutable(char) [] y = [3, 0, 1];
  assert(y[0] == 3);
  assert(y[1] == 0);
  assert(y[2] == 1);
  assert(y.length == 3);

}