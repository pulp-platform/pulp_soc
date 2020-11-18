#include <wide_alu_driver.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

void set_op(uint8_t operation)
{
  uint32_t volatile * ctrl2_reg = (uint32_t*)WIDE_ALU_CTRL2(0);
  uint32_t ctrl2_old_value;
  //Read old value
  ctrl2_old_value = *ctrl2_reg;
  //Overwrite operation bits
  *ctrl2_reg = ctrl2_old_value | (operation & WIDE_ALU_CTRL2_OPSEL_MASK)<<WIDE_ALU_CTRL2_OPSEL_LSB;
}


void set_delay(uint8_t delay)
{
  uint32_t volatile * ctrl2_reg = (uint32_t*)WIDE_ALU_CTRL2(0);
  uint32_t ctrl2_old_value;
  //Read old value
  ctrl2_old_value = *ctrl2_reg;
  //Overwrite operation bits
  *ctrl2_reg = ctrl2_old_value | (delay & WIDE_ALU_CTRL2_DELAY_MASK)<<WIDE_ALU_CTRL2_DELAY_LSB;
}


void trigger_op(void)
{
  uint32_t volatile * ctrl1_reg = (uint32_t*)WIDE_ALU_CTRL1(0);
  //Trigger operation by writing to trigger bit
  asm volatile("": : :"memory"); //Make sure gcc doesn't reorder the write to the trigger reg
  *ctrl1_reg = (1 & WIDE_ALU_CTRL1_TRIGGER_MASK)<<WIDE_ALU_CTRL1_TRIGGER_LSB;
  asm volatile("": : :"memory"); //Make sure gcc doesn't reorder the write to the trigger reg
}

void set_operands(uint32_t* a, uint32_t* b)
{
  uint32_t volatile * op_a_reg_start = (uint32_t*)WIDE_ALU_OP_A_0(0);
  uint32_t volatile * op_b_reg_start = (uint32_t*)WIDE_ALU_OP_B_0(0);
  //Make sure we are in idle state before changing the operands
  for (int i = 0; i<256/8; i++)
  {
    op_a_reg_start[i] = a[i];
    op_b_reg_start[i] = b[i];
  }
}

int poll_done(void)
{
  uint32_t volatile * status_reg = (uint32_t*)WIDE_ALU_STATUS(0);
  uint32_t current_status;
  do {
    current_status = (*status_reg>>WIDE_ALU_STATUS_CODE_LSB)&WIDE_ALU_STATUS_CODE_MASK;
  } while(current_status == WIDE_ALU_STATUS_CODE_PENDING);
  if (current_status == WIDE_ALU_STATUS_CODE_IDLE)
    return 0;
  else
    return current_status;
}

void get_result(uint32_t* result)
{
  uint32_t volatile * result_reg_start = (uint32_t*)WIDE_ALU_RESULT_0(0);
  for (int i = 0; i<512/8; i++)
  {
    result[i] = result_reg_start[i];
  }
}

void clear_error(void)
{
  uint32_t volatile * ctrl1_reg = (uint32_t*)WIDE_ALU_CTRL1(0);
  //Trigger operation by writing to trigger bit
  *ctrl1_reg = (1 & WIDE_ALU_CTRL1_CLEAR_ERR_MASK)<<WIDE_ALU_CTRL1_CLEAR_ERR_LSB;
}

int wide_multiply(uint32_t a[32], uint32_t b[32], uint32_t result[64])
{
  //Make sure the accelerator is in idle mode
  int status = poll_done();
  if (status != 0)
  {
    printf("Error setting up multiplication. Accelerator is in error state %d.\n", status);
    return status;
  }
  set_operands(a,b);
  set_op(WIDE_ALU_CTRL2_OPSEL_MUL);
  trigger_op();
  status = poll_done();
  if (status != 0)
  {
    printf("Operation failed with error code %d.\n", status);
    return status;
  }
  else
  {
    get_result(result);
    return 0;
  }
}
