localparam ASCII_SP = 8'h20;
localparam ASCII_TAB = 8'h9;
localparam ASCII_LF = 8'h0a;

typedef enum logic [5:0] {
    INIT,
    
    FETCH_IMP,
    
    CHECK_IMP_STACK,
    CHECK_IMP_TAB,
    CHECK_IMP_INT,
    CHECK_IMP_HEAP,
    CHECK_IMP_FLOW,
    CHECK_IMP_INOUT,

    CHECK_CMD_OUTPUT,
    
    STACK_STACKINT_READ_INT,

    HEAP_MEM_STORE_1,
    HEAP_MEM_STORE_2,

    HEAP_MEM_READ_1,
    HEAP_MEM_READ_2,

    PUSH_NUMBER
} statetype;

typedef enum logic [3:0] {
    IMP_STACK
} imptype;