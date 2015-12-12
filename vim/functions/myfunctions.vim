" PerlVim Functions
if has('perl')

function! GetCommentChar()
  if &ft == "vim"
    let comchar = '"'
  elseif &ft == "mt"
    let comchar = "%"
  elseif &ft == "xml" || &ft == "html"
    let comchar = "<!--"
  elseif &ft == "spice" || &ft == "spyce" || &ft == "spi" || &ft == "spf" || &ft == "dpf"
    let comchar = "*"
  elseif &ft == "vhdl" || &ft == "sql"
    let comchar = "-- "
  elseif &ft == "cpp" || &ft == "c" || &ft == "cs" || &ft == "java" || &ft == "javascript" || &ft == "php"
    let comchar = "//"
  else
    let comchar = "#" "Default comment char
  endif
  return comchar
endfunction "GetCommentChar

function! Comment() range
perl << EOF
  # Get comment character
  my $com_char = VIM::Eval('GetCommentChar()');
  my $end_com_char = '-->';

  # Get range if needed
  my $line1 = VIM::Eval('a:firstline');
  my $line2 = VIM::Eval('a:lastline');

  for (my $i=0; $i<=($line2-$line1); $i++) {
    my $line = $curbuf->Get($line1 + $i);
    if ($com_char eq '<!--') {
      $curbuf->Set($line1 + $i, "${com_char}${line}${end_com_char}");
    } else {
      $curbuf->Set($line1 + $i, "${com_char}${line}");
    }
  }
EOF
endfunction "Comment

function! UnComment() range
perl << EOF
  # Get comment character
  my $com_char = VIM::Eval('GetCommentChar()');
  my $end_com_char = '-->';

  # Escape special chars
  if ($com_char eq "*") {
    $com_char = "\\*";
  }

  # Get range if needed
  my $line1 = VIM::Eval('a:firstline');
  my $line2 = VIM::Eval('a:lastline');

  for (my $i=0; $i<=($line2-$line1); $i++) {
    my $line = $curbuf->Get($line1 + $i);
    if ($com_char eq '<!--') {
      $line =~ s/^\s*${com_char}//;
      $line =~ s/${end_com_char}\s*$//;
    } else {
      $line =~ s/^\s*${com_char}//;
    }
    $curbuf->Set($line1 + $i, "${line}");
  }
EOF
endfunction "UnComment

map <F7> :call Comment() <CR>
map <F8> :call UnComment() <CR>

endif "has_perl
