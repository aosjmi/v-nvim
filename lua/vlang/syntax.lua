-- lua/vlang/syntax.lua
local M = {}

function M.setup()
  -- すでにシンタックスが読み込まれていたら終了
  if vim.b.current_syntax then
    return
  end

  -- デフォルトのハイライトオプションを設定
  vim.g.v_highlight_array_whitespace_error = vim.g.v_highlight_array_whitespace_error or 1
  vim.g.v_highlight_chan_whitespace_error = vim.g.v_highlight_chan_whitespace_error or 1
  vim.g.v_highlight_space_tab_error = vim.g.v_highlight_space_tab_error or 1
  vim.g.v_highlight_trailing_whitespace_error = vim.g.v_highlight_trailing_whitespace_error or 1
  vim.g.v_highlight_function_calls = vim.g.v_highlight_function_calls or 1
  vim.g.v_highlight_fields = vim.g.v_highlight_fields or 1

  -- シンタックスハイライトルールを定義
  local cmd = vim.cmd
  
  cmd('syntax case match')

  -- 宣言タイプとキーワード
  cmd('syntax match vDeclType "\\<\\(struct\\|interface\\|type\\|enum\\)\\>"')
  cmd('syntax keyword vDeclaration pub mut var const')
  cmd('highlight default link vDeclType Keyword')
  cmd('highlight default link vDeclaration Keyword')

  -- ディレクティブ
  cmd('syntax keyword vDirective module import')
  cmd('highlight default link vDirective Statement')

  -- インクルード
  cmd('syntax region vIncluded display contained start=+"+ skip=+\\\\\\\\\\|\\\\"+ end=+"+"')
  cmd('syntax match vIncluded display contained "<[^>]*>"')
  cmd('syntax match vFlagDefinition display contained "\\s\\i[^\\n]*"')
  cmd('highlight default link vIncluded vString')
  cmd('highlight default link vFlagDefinition vString')

  cmd('syntax match vInclude display "^\\s*\\zs\\(%:\\|#\\)\\s*include\\>\\s*[\\"<]" contains=vIncluded')
  cmd('syntax match vFlag display "^\\s*\\zs\\(%:\\|#\\)\\s*flag\\>\\s*[^\\n]*" contains=vFlagDefinition')
  cmd('syntax region vShebang display start=/^#!/ end=/$/')
  cmd('highlight default link vInclude Include')
  cmd('highlight default link vFlag Include')
  cmd('highlight default link vShebang Include')

  -- 関数内のキーワード
  cmd('syntax keyword vStatement defer go goto return break continue')
  cmd('highlight default link vStatement Statement')

  -- 条件分岐
  cmd('syntax keyword vConditional if else match or select')
  cmd('highlight default link vConditional Conditional')

  -- 繰り返し
  cmd('syntax keyword vRepeat for in')
  cmd('highlight default link vRepeat Repeat')

  -- コード生成
  cmd('syntax match vCodeGen /$if\\>/')
  cmd('highlight default link vCodeGen Identifier')

  -- 定義済みの型
  cmd('syntax keyword vType any chan char map bool string error voidptr')
  cmd('syntax match vOptionalType "\\%(\\<?\\)\\@<=\\(chan\\|map\\|bool\\|string\\|error\\|voidptr\\)"')
  cmd('syntax keyword vSignedInts int i8 i16 i64 isize rune intptr')
  cmd('syntax keyword vUnsignedInts byte u16 u32 u64 usize byteptr')
  cmd('syntax keyword vFloats f32 f64 floatptr')

  cmd('highlight default link vType Type')
  cmd('highlight default link vOptionalType Type')
  cmd('highlight default link vSignedInts Type')
  cmd('highlight default link vUnsignedInts Type')
  cmd('highlight default link vFloats Type')

  -- 関数キーワードの特別処理
  cmd('syntax match vDeclaration /\\<fn\\>/')
  cmd('syntax match vDeclaration contained /\\<fn\\>/')

  -- 定義済みの関数と値
  cmd('syntax keyword vBuiltins assert C')
  cmd('syntax keyword vBuiltins complex exit imag')
  cmd('syntax keyword vBuiltins print println eprint eprintln')
  cmd('syntax keyword vBuiltins malloc copy memdup isnil')
  cmd('syntax keyword vBuiltins panic recover')
  cmd('syntax match vBuiltins /\\<json\\.\\(encode\\|decode\\)\\>/')
  cmd('highlight default link vBuiltins Keyword')

  -- 定数
  cmd('syntax keyword vConstants true false')
  cmd('highlight default link vConstants Keyword')

  -- コメント
  cmd('syntax keyword vTodo contained TODO FIXME XXX BUG')
  cmd('highlight default link vTodo Todo')

  cmd('syntax cluster vCommentGroup contains=vTodo')
  cmd('syntax region vComment start="/\\*" end="\\*/" contains=@vCommentGroup,@Spell')
  cmd('syntax region vComment start="//" end="$" contains=@vCommentGroup,@Spell')
  cmd('highlight default link vComment Comment')

  -- Vのエスケープ
  cmd('syntax match vStringVar display contained +\\$[0-9A-Za-z\\._]*\\([(][^)]*[)]\\)\\?+')
  cmd('syntax match vStringVar display contained "${[^}]*}"')
  cmd('syntax match vStringSpeChar display contained +\\\\[abfnrtv\\\\\'"\\`]+')
  cmd('syntax match vStringX display contained "\\\\x\\x\\{1,2}"')
  cmd('syntax match vStringU display contained "\\\\u\\x\\{4}"')
  cmd('syntax match vStringBigU display contained "\\\\U\\x\\{8}"')
  cmd('syntax match vStringError display contained +\\\\[^0-7xuUabfnrtv\\\\\'"]+')

  cmd('highlight default link vStringVar Special')
  cmd('highlight default link vStringSpeChar Special')
  cmd('highlight default link vStringX Special')
  cmd('highlight default link vStringU Special')
  cmd('highlight default link vStringBigU Special')
  cmd('highlight default link vStringError Error')

  -- 文字とその内容
  cmd('syntax cluster vCharacterGroup contains=vStringSpeChar,vStringVar,vStringX,vStringU,vStringBigU')
  cmd('syntax region vCharacter start=+`+ end=+`+ contains=@vCharacterGroup')
  cmd('highlight default link vCharacter Character')

  -- 文字列とその内容
  cmd('syntax cluster vStringGroup contains=@vCharacterGroup,vStringError')
  
  cmd('syntax region vString start=+"+ skip=+\\\\\\\\\\|\\\\'+ end=+"+ contains=@vStringGroup')
  cmd('syntax region vString start=+\'+ skip=+\\\\\\\\\\|\\\\'+ end=+\'+ contains=@vStringGroup')
  
  cmd('syntax region vRawString start=+r"+ end=+"+ ')
  cmd('syntax region vRawString start=+r\'+ end=+\'+ ')
  
  cmd('highlight default link vString String')
  cmd('highlight default link vRawString String')

  -- リージョン
  cmd('syntax region vBlock start="{" end="}" transparent fold')
  cmd('syntax region vParen start=\'(\' end=\')\' transparent')

  -- 整数
  cmd('syntax match vDecimalInt "\\<\\d\\+\\([Ee]\\d\\+\\)\\?\\>"')
  cmd('syntax match vOctalInt "\\<0o\\o\\+\\>"')
  cmd('syntax match vHexInt "\\<0x\\x\\+\\>"')
  cmd('syntax match vBinaryInt "\\<0b[01]\\+\\>"')
  cmd('syntax match vSnakeInt "\\<[0-9_]\\+\\>"')

  cmd('highlight default link vDecimalInt Integer')
  cmd('highlight default link vOctalInt Integer')
  cmd('highlight default link vHexInt Integer')
  cmd('highlight default link vBinaryInt Integer')
  cmd('highlight default link vSnakeInt Integer')
  cmd('highlight default link Integer Number')

  -- 浮動小数点
  cmd('syntax match vFloat "\\<\\d\\+\\.\\d*\\([Ee][-+]\\d\\+\\)\\?\\>"')
  cmd('syntax match vFloat "\\<\\.\\d\\+\\([Ee][-+]\\d\\+\\)\\?\\>"')
  cmd('syntax match vFloat "\\<\\d\\+[Ee][-+]\\d\\+\\>"')
  
  cmd('highlight default link vFloat Float')
  cmd('highlight default link Float Number')

  -- ジェネリクス
  cmd('syntax match vGenericBrackets display contained "[<>]"')
  cmd('syntax match vInterfaceDeclaration display "\\s*\\zsinterface\\s*\\i*\\s*<[^>]*>" contains=vDeclType,vGenericBrackets')
  cmd('syntax match vStructDeclaration display "\\s*\\zsstruct\\s*\\i*\\s*<[^>]*>" contains=vDeclType,vGenericBrackets')
  cmd('syntax match vFuncDeclaration display "\\s*\\zsfn\\s*\\i*\\s*<[^>]*>" contains=vFunctionName,vDeclaration,vGenericBrackets')
  
  cmd('highlight default link vGenericBrackets Identifier')

  -- "[]" の後のスペース
  if vim.g.v_highlight_array_whitespace_error ~= 0 then
    cmd('syntax match vSpaceError display "\\(\\[\\]\\)\\@<=\\s\\+"')
  end

  -- 'chan' キーワード周辺のスペースエラー
  if vim.g.v_highlight_chan_whitespace_error ~= 0 then
    -- チャネル型の受信専用アノテーション
    cmd('syntax match vSpaceError display "\\(<-\\)\\@<=\\s\\+\\(chan\\>\\)\\@="')
    -- チャネル型の送信専用アノテーション
    cmd('syntax match vSpaceError display "\\(\\<chan\\)\\@<=\\s\\+\\(<-\\)\\@="')
    -- いくつかのコンテキストでの値を無視する受信
    cmd('syntax match vSpaceError display "\\(\\(^\\|[={\\(,;]\\)\\s*<-\\)\\@<=\\s\\+"')
  end

  -- スペースとタブのエラー
  if vim.g.v_highlight_space_tab_error ~= 0 then
    cmd('syntax match vSpaceError display " \\+\\t"me=e-1')
  end

  -- 末尾の空白エラー
  if vim.g.v_highlight_trailing_whitespace_error ~= 0 then
    cmd('syntax match vSpaceError display excludenl "\\s\\+$"')
  end

  cmd('highlight default link vSpaceError Error')

  -- 関数呼び出し
  if vim.g.v_highlight_function_calls ~= 0 then
    cmd('syntax match vFunctionCall /\\w\\+\\ze\\s*(/ contains=vBuiltins,vDeclaration')
    cmd('syntax match vFunctionName display contained /\\s\\w\\+/')
    cmd('highlight default link vFunctionName Special')
  end

  cmd('highlight default link vFunctionCall Special')

  -- フィールド
  if vim.g.v_highlight_fields ~= 0 then
    cmd([[
      syntax match vField /\.\w\+\
            \%(\%([\/\-\+*%]\)\|\
            \%([\[\]{}<\>\)]\)\|\
            \%([\!=\^|&]\)\|\
            \%([\n\r\ ]\)\|\
            \%([,\:.]\)\)\@=/hs=s+1
    ]])
  end
  cmd('highlight default link vField Identifier')

  -- 同期
  cmd('syntax sync minlines=500')

  vim.b.current_syntax = "vlang"
end

return M
