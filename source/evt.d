module evt;

import std.typecons;
import std.traits;
import std.conv;

import transforms.snake;


import std.stdio;
// import tagged_union;

enum EvtOp {
  Reference = 'R', // instance of a new file (like create) or overwrite but based on a file image, from a snapshot.
  Create = 'C',    // create a new file. doesn't contain data. doesn't need to be called before `Reference`.
  Write = 'W',     // write data to a specific offset of a file. The file may grow if data is written after the end.
  Truncate = 'T',  // truncate a file from a specific offset until the end. doesn't contain data.
  Move = 'M',      // move a file or rename it.
  MoveDir = 'm',   // move a directory or rename it.
  Delete = 'D',    // delete a file.
  CreateDir = 'c', // create a new directory.
  DeleteDir = 'd', // delete an empty directory.
  Symlink = 'S',   // create or replace a symbolic link.
  // Handshake = 'H', // protocol operations to reach consensus over setting a new snapshot for a file.
  // Patch = 'P',     // similar to write but using diff format, for a text file.


};

alias FilePathType = string;
alias EvtTimestampType = string;
alias EvtRandomIdType = string;
alias EvtOffsetType = long;
alias EvtSizeType = long;
alias EvtChecksumType = string;

alias EvtDataType = immutable(char)[];

struct EvtHeaderCommon {
  FilePathType file_path;
  EvtTimestampType evt_timestamp; // id is timestamp first, checksum last. timestamp is autoincremented to avoid dupl.
  EvtChecksumType evt_checksum;
};

struct ReferenceEvt {
  alias op = EvtOp.Reference;
  alias hdr_com = hdr;

  EvtHeaderCommon hdr;

  EvtTimestampType snap_timestamp;
  EvtChecksumType snap_checksum;
};


struct WriteEvt {
  alias op = EvtOp.Write;
  alias hdr_com = hdr;

  EvtHeaderCommon hdr;
  EvtOffsetType evt_offset;
  EvtSizeType evt_size;

  EvtDataType* data;

  unittest {
    WriteEvt ev;
    assert(ev.op == EvtOp.Write);
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
pure EvtOffsetType get_evt_offset(T)(T evt) { return evt.evt_offset; }

struct Evt {

  private:
    union {

      WriteEvt write_evt;
      DeleteEvt delete_evt;
    };

    EvtOp op_tag;

    string switch_generate() {
      string s;
      writeln((EnumMembers!EvtOp)[0].mangleof);
      writeln((EnumMembers!EvtOp)[1].mangleof);
      writeln((EnumMembers!EvtOp)[0]);
      writeln((EnumMembers!EvtOp)[1]);
      foreach(m, d; [EnumMembers!EvtOp]) {

        string x = to!string (d);
        // string s = d;
        writeln(x);
      }

      foreach(m; [EnumMembers!EvtOp]) {
        string x = to!string(m);
        s ~= "case Evt." ~ x;
        s ~= ": return fun(" ~ x.snakeCase ~ "_evt);\n";
      }

      return s;
    }

  public:
    this(WriteEvt rhs) {
      op_tag = rhs.op;
      this.write_evt = rhs;
    }

    this(DeleteEvt rhs) {
      op_tag = rhs.op;
      this.delete_evt = rhs;
    }



    auto ref apply(alias fun)() {

  //    string res = "final switch(" ~ op_tag ~ "){";
  //foreach(m;__traits(allMembers,T)){
  //  res ~= "case " ~ templateVar ~ "." ~ m ~ ": return \"" ~ pre ~ m ~ "\";";
  //}
  //res ~= "}";
  //return res;


      //final switch(op_tag) with(EvtOp) {
      //  case Write:
      //    return fun(write_evt);

      //  case Delete:
      //    return fun(delete_evt);
      //}
      return fun(write_evt);
    }

  unittest {

    WriteEvt write_evt;
    Evt evt = write_evt;

    assert(evt.op_tag == EvtOp.Write);
    assert(evt.apply!get_op() == EvtOp.Write);
    EvtHeaderCommon hdr_com = evt.apply!get_hdr_com();

  }

};

pure auto spatial_less_extract(Evt a) {
  auto hdr_a = a.apply!get_hdr_com();
  auto evt_offset = a.apply!get_evt_offset();
  auto tpl_a = tuple(hdr_a.file_path, evt_offset);

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

unittest {
  WriteEvt write_evt;
  Evt evt = write_evt;

  writeln(evt.switch_generate());
  // return 0;
}