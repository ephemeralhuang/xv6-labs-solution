
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	93013103          	ld	sp,-1744(sp) # 80008930 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	133050ef          	jal	ra,80005948 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fd078793          	addi	a5,a5,-48 # 80022000 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	94090913          	addi	s2,s2,-1728 # 80008990 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2da080e7          	jalr	730(ra) # 80006334 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	37a080e7          	jalr	890(ra) # 800063e8 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d72080e7          	jalr	-654(ra) # 80005dfc <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	8a250513          	addi	a0,a0,-1886 # 80008990 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	1ae080e7          	jalr	430(ra) # 800062a4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	efe50513          	addi	a0,a0,-258 # 80022000 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	86c48493          	addi	s1,s1,-1940 # 80008990 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	206080e7          	jalr	518(ra) # 80006334 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	85450513          	addi	a0,a0,-1964 # 80008990 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	2a2080e7          	jalr	674(ra) # 800063e8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	82850513          	addi	a0,a0,-2008 # 80008990 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	278080e7          	jalr	632(ra) # 800063e8 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd001>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	bea080e7          	jalr	-1046(ra) # 80000f12 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	62070713          	addi	a4,a4,1568 # 80008950 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	bce080e7          	jalr	-1074(ra) # 80000f12 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	af0080e7          	jalr	-1296(ra) # 80005e46 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8f8080e7          	jalr	-1800(ra) # 80001c5e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f92080e7          	jalr	-110(ra) # 80005300 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	140080e7          	jalr	320(ra) # 800014b6 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	98e080e7          	jalr	-1650(ra) # 80005d0c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	ca0080e7          	jalr	-864(ra) # 80006026 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	ab0080e7          	jalr	-1360(ra) # 80005e46 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	aa0080e7          	jalr	-1376(ra) # 80005e46 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a90080e7          	jalr	-1392(ra) # 80005e46 <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	a8a080e7          	jalr	-1398(ra) # 80000e60 <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	858080e7          	jalr	-1960(ra) # 80001c36 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	878080e7          	jalr	-1928(ra) # 80001c5e <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	efc080e7          	jalr	-260(ra) # 800052ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	f0a080e7          	jalr	-246(ra) # 80005300 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	08c080e7          	jalr	140(ra) # 8000248a <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	72c080e7          	jalr	1836(ra) # 80002b32 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	6d2080e7          	jalr	1746(ra) # 80003ae0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ff2080e7          	jalr	-14(ra) # 80005408 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	e7a080e7          	jalr	-390(ra) # 80001298 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	52f72223          	sw	a5,1316(a4) # 80008950 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	5207b783          	ld	a5,1312(a5) # 80008960 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    panic("walk");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	970080e7          	jalr	-1680(ra) # 80005dfc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcff7>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
        return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    return 0;
    8000050c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if(pte == 0)
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000524:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    return 0;
    8000052c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
    return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if(*pte & PTE_V)
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
    panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00006097          	auipc	ra,0x6
    800005b6:	84a080e7          	jalr	-1974(ra) # 80005dfc <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00006097          	auipc	ra,0x6
    800005c6:	83a080e7          	jalr	-1990(ra) # 80005dfc <panic>
      return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
{
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
    panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	7ee080e7          	jalr	2030(ra) # 80005dfc <panic>

0000000080000616 <kvmmake>:
{
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	6f6080e7          	jalr	1782(ra) # 80000dcc <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
{
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	26a7b223          	sd	a0,612(a5) # 80008960 <kernel_pagetable>
}
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
    panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	6a2080e7          	jalr	1698(ra) # 80005dfc <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	692080e7          	jalr	1682(ra) # 80005dfc <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	682080e7          	jalr	1666(ra) # 80005dfc <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	672080e7          	jalr	1650(ra) # 80005dfc <panic>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
    if(do_free){
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e4:	c519                	beqz	a0,800007f2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e6:	6605                	lui	a2,0x1
    800007e8:	4581                	li	a1,0
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  return pagetable;
}
    800007f2:	8526                	mv	a0,s1
    800007f4:	60e2                	ld	ra,24(sp)
    800007f6:	6442                	ld	s0,16(sp)
    800007f8:	64a2                	ld	s1,8(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fe:	7179                	addi	sp,sp,-48
    80000800:	f406                	sd	ra,40(sp)
    80000802:	f022                	sd	s0,32(sp)
    80000804:	ec26                	sd	s1,24(sp)
    80000806:	e84a                	sd	s2,16(sp)
    80000808:	e44e                	sd	s3,8(sp)
    8000080a:	e052                	sd	s4,0(sp)
    8000080c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080e:	6785                	lui	a5,0x1
    80000810:	04f67863          	bgeu	a2,a5,80000860 <uvmfirst+0x62>
    80000814:	8a2a                	mv	s4,a0
    80000816:	89ae                	mv	s3,a1
    80000818:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	900080e7          	jalr	-1792(ra) # 8000011a <kalloc>
    80000822:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	952080e7          	jalr	-1710(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000830:	4779                	li	a4,30
    80000832:	86ca                	mv	a3,s2
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	8552                	mv	a0,s4
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	d0c080e7          	jalr	-756(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000842:	8626                	mv	a2,s1
    80000844:	85ce                	mv	a1,s3
    80000846:	854a                	mv	a0,s2
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	98e080e7          	jalr	-1650(ra) # 800001d6 <memmove>
}
    80000850:	70a2                	ld	ra,40(sp)
    80000852:	7402                	ld	s0,32(sp)
    80000854:	64e2                	ld	s1,24(sp)
    80000856:	6942                	ld	s2,16(sp)
    80000858:	69a2                	ld	s3,8(sp)
    8000085a:	6a02                	ld	s4,0(sp)
    8000085c:	6145                	addi	sp,sp,48
    8000085e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	87850513          	addi	a0,a0,-1928 # 800080d8 <etext+0xd8>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	594080e7          	jalr	1428(ra) # 80005dfc <panic>

0000000080000870 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000882:	6785                	lui	a5,0x1
    80000884:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000886:	00f60733          	add	a4,a2,a5
    8000088a:	76fd                	lui	a3,0xfffff
    8000088c:	8f75                	and	a4,a4,a3
    8000088e:	97ae                	add	a5,a5,a1
    80000890:	8ff5                	and	a5,a5,a3
    80000892:	00f76863          	bltu	a4,a5,800008a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000896:	8526                	mv	a0,s1
    80000898:	60e2                	ld	ra,24(sp)
    8000089a:	6442                	ld	s0,16(sp)
    8000089c:	64a2                	ld	s1,8(sp)
    8000089e:	6105                	addi	sp,sp,32
    800008a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a2:	8f99                	sub	a5,a5,a4
    800008a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a6:	4685                	li	a3,1
    800008a8:	0007861b          	sext.w	a2,a5
    800008ac:	85ba                	mv	a1,a4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	e5e080e7          	jalr	-418(ra) # 8000070c <uvmunmap>
    800008b6:	b7c5                	j	80000896 <uvmdealloc+0x26>

00000000800008b8 <uvmalloc>:
  if(newsz < oldsz)
    800008b8:	0ab66563          	bltu	a2,a1,80000962 <uvmalloc+0xaa>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	77fd                	lui	a5,0xfffff
    800008dc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000916:	6785                	lui	a5,0x1
    80000918:	993e                	add	s2,s2,a5
    8000091a:	fd4968e3          	bltu	s2,s4,800008ea <uvmalloc+0x32>
  return newsz;
    8000091e:	8552                	mv	a0,s4
    80000920:	a809                	j	80000932 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	864e                	mv	a2,s3
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	f48080e7          	jalr	-184(ra) # 80000870 <uvmdealloc>
      return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	74a2                	ld	s1,40(sp)
    80000938:	7902                	ld	s2,32(sp)
    8000093a:	69e2                	ld	s3,24(sp)
    8000093c:	6a42                	ld	s4,16(sp)
    8000093e:	6aa2                	ld	s5,8(sp)
    80000940:	6b02                	ld	s6,0(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1a080e7          	jalr	-230(ra) # 80000870 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	bfc9                	j	80000932 <uvmalloc+0x7a>
    return oldsz;
    80000962:	852e                	mv	a0,a1
}
    80000964:	8082                	ret
  return newsz;
    80000966:	8532                	mv	a0,a2
    80000968:	b7e9                	j	80000932 <uvmalloc+0x7a>

000000008000096a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096a:	7179                	addi	sp,sp,-48
    8000096c:	f406                	sd	ra,40(sp)
    8000096e:	f022                	sd	s0,32(sp)
    80000970:	ec26                	sd	s1,24(sp)
    80000972:	e84a                	sd	s2,16(sp)
    80000974:	e44e                	sd	s3,8(sp)
    80000976:	e052                	sd	s4,0(sp)
    80000978:	1800                	addi	s0,sp,48
    8000097a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000982:	4985                	li	s3,1
    80000984:	a829                	j	8000099e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000986:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000988:	00c79513          	slli	a0,a5,0xc
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	fde080e7          	jalr	-34(ra) # 8000096a <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	448080e7          	jalr	1096(ra) # 80005dfc <panic>
    }
  }
  kfree((void*)pagetable);
    800009bc:	8552                	mv	a0,s4
    800009be:	fffff097          	auipc	ra,0xfffff
    800009c2:	65e080e7          	jalr	1630(ra) # 8000001c <kfree>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e4:	8526                	mv	a0,s1
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	f84080e7          	jalr	-124(ra) # 8000096a <freewalk>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fc:	95be                	add	a1,a1,a5
    800009fe:	4685                	li	a3,1
    80000a00:	00c5d613          	srli	a2,a1,0xc
    80000a04:	4581                	li	a1,0
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	d06080e7          	jalr	-762(ra) # 8000070c <uvmunmap>
    80000a0e:	bfd9                	j	800009e4 <uvmfree+0xe>

0000000080000a10 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a10:	c679                	beqz	a2,80000ade <uvmcopy+0xce>
{
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	8b2a                	mv	s6,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	36a080e7          	jalr	874(ra) # 80005dfc <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	35a080e7          	jalr	858(ra) # 80005dfc <panic>
      kfree(mem);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	570080e7          	jalr	1392(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab4:	4685                	li	a3,1
    80000ab6:	00c9d613          	srli	a2,s3,0xc
    80000aba:	4581                	li	a1,0
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	c4e080e7          	jalr	-946(ra) # 8000070c <uvmunmap>
  return -1;
    80000ac6:	557d                	li	a0,-1
}
    80000ac8:	60a6                	ld	ra,72(sp)
    80000aca:	6406                	ld	s0,64(sp)
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	7a02                	ld	s4,32(sp)
    80000ad4:	6ae2                	ld	s5,24(sp)
    80000ad6:	6b42                	ld	s6,16(sp)
    80000ad8:	6ba2                	ld	s7,8(sp)
    80000ada:	6161                	addi	sp,sp,80
    80000adc:	8082                	ret
  return 0;
    80000ade:	4501                	li	a0,0
}
    80000ae0:	8082                	ret

0000000080000ae2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	972080e7          	jalr	-1678(ra) # 8000045e <walk>
  if(pte == 0)
    80000af4:	c901                	beqz	a0,80000b04 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af6:	611c                	ld	a5,0(a0)
    80000af8:	9bbd                	andi	a5,a5,-17
    80000afa:	e11c                	sd	a5,0(a0)
}
    80000afc:	60a2                	ld	ra,8(sp)
    80000afe:	6402                	ld	s0,0(sp)
    80000b00:	0141                	addi	sp,sp,16
    80000b02:	8082                	ret
    panic("uvmclear");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	64450513          	addi	a0,a0,1604 # 80008148 <etext+0x148>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	2f0080e7          	jalr	752(ra) # 80005dfc <panic>

0000000080000b14 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b14:	c6bd                	beqz	a3,80000b82 <copyout+0x6e>
{
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	e062                	sd	s8,0(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8c2e                	mv	s8,a1
    80000b32:	8a32                	mv	s4,a2
    80000b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b36:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3c:	9562                	add	a0,a0,s8
    80000b3e:	0004861b          	sext.w	a2,s1
    80000b42:	85d2                	mv	a1,s4
    80000b44:	41250533          	sub	a0,a0,s2
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	68e080e7          	jalr	1678(ra) # 800001d6 <memmove>

    len -= n;
    80000b50:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b54:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b56:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000b6e:	cd01                	beqz	a0,80000b86 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b70:	418904b3          	sub	s1,s2,s8
    80000b74:	94d6                	add	s1,s1,s5
    80000b76:	fc99f3e3          	bgeu	s3,s1,80000b3c <copyout+0x28>
    80000b7a:	84ce                	mv	s1,s3
    80000b7c:	b7c1                	j	80000b3c <copyout+0x28>
  }
  return 0;
    80000b7e:	4501                	li	a0,0
    80000b80:	a021                	j	80000b88 <copyout+0x74>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
      return -1;
    80000b86:	557d                	li	a0,-1
}
    80000b88:	60a6                	ld	ra,72(sp)
    80000b8a:	6406                	ld	s0,64(sp)
    80000b8c:	74e2                	ld	s1,56(sp)
    80000b8e:	7942                	ld	s2,48(sp)
    80000b90:	79a2                	ld	s3,40(sp)
    80000b92:	7a02                	ld	s4,32(sp)
    80000b94:	6ae2                	ld	s5,24(sp)
    80000b96:	6b42                	ld	s6,16(sp)
    80000b98:	6ba2                	ld	s7,8(sp)
    80000b9a:	6c02                	ld	s8,0(sp)
    80000b9c:	6161                	addi	sp,sp,80
    80000b9e:	8082                	ret

0000000080000ba0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba0:	caa5                	beqz	a3,80000c10 <copyin+0x70>
{
    80000ba2:	715d                	addi	sp,sp,-80
    80000ba4:	e486                	sd	ra,72(sp)
    80000ba6:	e0a2                	sd	s0,64(sp)
    80000ba8:	fc26                	sd	s1,56(sp)
    80000baa:	f84a                	sd	s2,48(sp)
    80000bac:	f44e                	sd	s3,40(sp)
    80000bae:	f052                	sd	s4,32(sp)
    80000bb0:	ec56                	sd	s5,24(sp)
    80000bb2:	e85a                	sd	s6,16(sp)
    80000bb4:	e45e                	sd	s7,8(sp)
    80000bb6:	e062                	sd	s8,0(sp)
    80000bb8:	0880                	addi	s0,sp,80
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	8a2e                	mv	s4,a1
    80000bbe:	8c32                	mv	s8,a2
    80000bc0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc8:	018505b3          	add	a1,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412585b3          	sub	a1,a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    80000c04:	fc99f2e3          	bgeu	s3,s1,80000bc8 <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	bf7d                	j	80000bc8 <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x76>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c2dd                	beqz	a3,80000cd4 <copyinstr+0xa6>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c76:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cae:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd000>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
      --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc4:	fed796e3          	bne	a5,a3,80000cb0 <copyinstr+0x82>
      dst++;
    80000cc8:	8b3e                	mv	s6,a5
    80000cca:	b775                	j	80000c76 <copyinstr+0x48>
    80000ccc:	4781                	li	a5,0
    80000cce:	b771                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd0:	557d                	li	a0,-1
    80000cd2:	b779                	j	80000c60 <copyinstr+0x32>
  int got_null = 0;
    80000cd4:	4781                	li	a5,0
  if(got_null){
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <vmprint>:

static int printdeep = 0;

void
vmprint(pagetable_t pagetable)
{
    80000cde:	711d                	addi	sp,sp,-96
    80000ce0:	ec86                	sd	ra,88(sp)
    80000ce2:	e8a2                	sd	s0,80(sp)
    80000ce4:	e4a6                	sd	s1,72(sp)
    80000ce6:	e0ca                	sd	s2,64(sp)
    80000ce8:	fc4e                	sd	s3,56(sp)
    80000cea:	f852                	sd	s4,48(sp)
    80000cec:	f456                	sd	s5,40(sp)
    80000cee:	f05a                	sd	s6,32(sp)
    80000cf0:	ec5e                	sd	s7,24(sp)
    80000cf2:	e862                	sd	s8,16(sp)
    80000cf4:	e466                	sd	s9,8(sp)
    80000cf6:	e06a                	sd	s10,0(sp)
    80000cf8:	1080                	addi	s0,sp,96
    80000cfa:	8a2a                	mv	s4,a0
  if (printdeep == 0)
    80000cfc:	00008797          	auipc	a5,0x8
    80000d00:	c5c7a783          	lw	a5,-932(a5) # 80008958 <printdeep>
    80000d04:	c39d                	beqz	a5,80000d2a <vmprint+0x4c>
{
    80000d06:	4981                	li	s3,0
    printf("page table %p\n", (uint64)pagetable);
  for (int i = 0; i < 512; i++) {
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
      for (int j = 0; j <= printdeep; j++) {
    80000d08:	00008a97          	auipc	s5,0x8
    80000d0c:	c50a8a93          	addi	s5,s5,-944 # 80008958 <printdeep>
        printf("..");
      }
      printf("%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    80000d10:	00007c97          	auipc	s9,0x7
    80000d14:	460c8c93          	addi	s9,s9,1120 # 80008170 <etext+0x170>
      for (int j = 0; j <= printdeep; j++) {
    80000d18:	4d01                	li	s10,0
        printf("..");
    80000d1a:	00007b17          	auipc	s6,0x7
    80000d1e:	44eb0b13          	addi	s6,s6,1102 # 80008168 <etext+0x168>
    }
    // pintes to lower-level page table
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d22:	4c05                	li	s8,1
  for (int i = 0; i < 512; i++) {
    80000d24:	20000b93          	li	s7,512
    80000d28:	a82d                	j	80000d62 <vmprint+0x84>
    printf("page table %p\n", (uint64)pagetable);
    80000d2a:	85aa                	mv	a1,a0
    80000d2c:	00007517          	auipc	a0,0x7
    80000d30:	42c50513          	addi	a0,a0,1068 # 80008158 <etext+0x158>
    80000d34:	00005097          	auipc	ra,0x5
    80000d38:	112080e7          	jalr	274(ra) # 80005e46 <printf>
    80000d3c:	b7e9                	j	80000d06 <vmprint+0x28>
      printf("%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    80000d3e:	00a95693          	srli	a3,s2,0xa
    80000d42:	06b2                	slli	a3,a3,0xc
    80000d44:	864a                	mv	a2,s2
    80000d46:	85ce                	mv	a1,s3
    80000d48:	8566                	mv	a0,s9
    80000d4a:	00005097          	auipc	ra,0x5
    80000d4e:	0fc080e7          	jalr	252(ra) # 80005e46 <printf>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d52:	00f97793          	andi	a5,s2,15
    80000d56:	03878b63          	beq	a5,s8,80000d8c <vmprint+0xae>
  for (int i = 0; i < 512; i++) {
    80000d5a:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000d5c:	0a21                	addi	s4,s4,8
    80000d5e:	05798963          	beq	s3,s7,80000db0 <vmprint+0xd2>
    pte_t pte = pagetable[i];
    80000d62:	000a3903          	ld	s2,0(s4)
    if (pte & PTE_V) {
    80000d66:	00197793          	andi	a5,s2,1
    80000d6a:	d7e5                	beqz	a5,80000d52 <vmprint+0x74>
      for (int j = 0; j <= printdeep; j++) {
    80000d6c:	000aa783          	lw	a5,0(s5)
    80000d70:	fc07c7e3          	bltz	a5,80000d3e <vmprint+0x60>
    80000d74:	84ea                	mv	s1,s10
        printf("..");
    80000d76:	855a                	mv	a0,s6
    80000d78:	00005097          	auipc	ra,0x5
    80000d7c:	0ce080e7          	jalr	206(ra) # 80005e46 <printf>
      for (int j = 0; j <= printdeep; j++) {
    80000d80:	2485                	addiw	s1,s1,1
    80000d82:	000aa783          	lw	a5,0(s5)
    80000d86:	fe97d8e3          	bge	a5,s1,80000d76 <vmprint+0x98>
    80000d8a:	bf55                	j	80000d3e <vmprint+0x60>
      printdeep++;
    80000d8c:	000aa783          	lw	a5,0(s5)
    80000d90:	2785                	addiw	a5,a5,1
    80000d92:	00faa023          	sw	a5,0(s5)
      uint64 child_pa = PTE2PA(pte);
    80000d96:	00a95513          	srli	a0,s2,0xa
      vmprint((pagetable_t)child_pa);
    80000d9a:	0532                	slli	a0,a0,0xc
    80000d9c:	00000097          	auipc	ra,0x0
    80000da0:	f42080e7          	jalr	-190(ra) # 80000cde <vmprint>
      printdeep--;
    80000da4:	000aa783          	lw	a5,0(s5)
    80000da8:	37fd                	addiw	a5,a5,-1
    80000daa:	00faa023          	sw	a5,0(s5)
    80000dae:	b775                	j	80000d5a <vmprint+0x7c>
    }
  }
    80000db0:	60e6                	ld	ra,88(sp)
    80000db2:	6446                	ld	s0,80(sp)
    80000db4:	64a6                	ld	s1,72(sp)
    80000db6:	6906                	ld	s2,64(sp)
    80000db8:	79e2                	ld	s3,56(sp)
    80000dba:	7a42                	ld	s4,48(sp)
    80000dbc:	7aa2                	ld	s5,40(sp)
    80000dbe:	7b02                	ld	s6,32(sp)
    80000dc0:	6be2                	ld	s7,24(sp)
    80000dc2:	6c42                	ld	s8,16(sp)
    80000dc4:	6ca2                	ld	s9,8(sp)
    80000dc6:	6d02                	ld	s10,0(sp)
    80000dc8:	6125                	addi	sp,sp,96
    80000dca:	8082                	ret

0000000080000dcc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dcc:	7139                	addi	sp,sp,-64
    80000dce:	fc06                	sd	ra,56(sp)
    80000dd0:	f822                	sd	s0,48(sp)
    80000dd2:	f426                	sd	s1,40(sp)
    80000dd4:	f04a                	sd	s2,32(sp)
    80000dd6:	ec4e                	sd	s3,24(sp)
    80000dd8:	e852                	sd	s4,16(sp)
    80000dda:	e456                	sd	s5,8(sp)
    80000ddc:	e05a                	sd	s6,0(sp)
    80000dde:	0080                	addi	s0,sp,64
    80000de0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de2:	00008497          	auipc	s1,0x8
    80000de6:	ffe48493          	addi	s1,s1,-2 # 80008de0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dea:	8b26                	mv	s6,s1
    80000dec:	00007a97          	auipc	s5,0x7
    80000df0:	214a8a93          	addi	s5,s5,532 # 80008000 <etext>
    80000df4:	01000937          	lui	s2,0x1000
    80000df8:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000dfa:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	0000ea17          	auipc	s4,0xe
    80000e00:	be4a0a13          	addi	s4,s4,-1052 # 8000e9e0 <tickslock>
    char *pa = kalloc();
    80000e04:	fffff097          	auipc	ra,0xfffff
    80000e08:	316080e7          	jalr	790(ra) # 8000011a <kalloc>
    80000e0c:	862a                	mv	a2,a0
    if(pa == 0)
    80000e0e:	c129                	beqz	a0,80000e50 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e10:	416485b3          	sub	a1,s1,s6
    80000e14:	8591                	srai	a1,a1,0x4
    80000e16:	000ab783          	ld	a5,0(s5)
    80000e1a:	02f585b3          	mul	a1,a1,a5
    80000e1e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e22:	4719                	li	a4,6
    80000e24:	6685                	lui	a3,0x1
    80000e26:	40b905b3          	sub	a1,s2,a1
    80000e2a:	854e                	mv	a0,s3
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	7ba080e7          	jalr	1978(ra) # 800005e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	17048493          	addi	s1,s1,368
    80000e38:	fd4496e3          	bne	s1,s4,80000e04 <proc_mapstacks+0x38>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret
      panic("kalloc");
    80000e50:	00007517          	auipc	a0,0x7
    80000e54:	33850513          	addi	a0,a0,824 # 80008188 <etext+0x188>
    80000e58:	00005097          	auipc	ra,0x5
    80000e5c:	fa4080e7          	jalr	-92(ra) # 80005dfc <panic>

0000000080000e60 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e60:	7139                	addi	sp,sp,-64
    80000e62:	fc06                	sd	ra,56(sp)
    80000e64:	f822                	sd	s0,48(sp)
    80000e66:	f426                	sd	s1,40(sp)
    80000e68:	f04a                	sd	s2,32(sp)
    80000e6a:	ec4e                	sd	s3,24(sp)
    80000e6c:	e852                	sd	s4,16(sp)
    80000e6e:	e456                	sd	s5,8(sp)
    80000e70:	e05a                	sd	s6,0(sp)
    80000e72:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e74:	00007597          	auipc	a1,0x7
    80000e78:	31c58593          	addi	a1,a1,796 # 80008190 <etext+0x190>
    80000e7c:	00008517          	auipc	a0,0x8
    80000e80:	b3450513          	addi	a0,a0,-1228 # 800089b0 <pid_lock>
    80000e84:	00005097          	auipc	ra,0x5
    80000e88:	420080e7          	jalr	1056(ra) # 800062a4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e8c:	00007597          	auipc	a1,0x7
    80000e90:	30c58593          	addi	a1,a1,780 # 80008198 <etext+0x198>
    80000e94:	00008517          	auipc	a0,0x8
    80000e98:	b3450513          	addi	a0,a0,-1228 # 800089c8 <wait_lock>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	408080e7          	jalr	1032(ra) # 800062a4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea4:	00008497          	auipc	s1,0x8
    80000ea8:	f3c48493          	addi	s1,s1,-196 # 80008de0 <proc>
      initlock(&p->lock, "proc");
    80000eac:	00007b17          	auipc	s6,0x7
    80000eb0:	2fcb0b13          	addi	s6,s6,764 # 800081a8 <etext+0x1a8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eb4:	8aa6                	mv	s5,s1
    80000eb6:	00007a17          	auipc	s4,0x7
    80000eba:	14aa0a13          	addi	s4,s4,330 # 80008000 <etext>
    80000ebe:	01000937          	lui	s2,0x1000
    80000ec2:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ec4:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec6:	0000e997          	auipc	s3,0xe
    80000eca:	b1a98993          	addi	s3,s3,-1254 # 8000e9e0 <tickslock>
      initlock(&p->lock, "proc");
    80000ece:	85da                	mv	a1,s6
    80000ed0:	8526                	mv	a0,s1
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	3d2080e7          	jalr	978(ra) # 800062a4 <initlock>
      p->state = UNUSED;
    80000eda:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ede:	415487b3          	sub	a5,s1,s5
    80000ee2:	8791                	srai	a5,a5,0x4
    80000ee4:	000a3703          	ld	a4,0(s4)
    80000ee8:	02e787b3          	mul	a5,a5,a4
    80000eec:	00d7979b          	slliw	a5,a5,0xd
    80000ef0:	40f907b3          	sub	a5,s2,a5
    80000ef4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef6:	17048493          	addi	s1,s1,368
    80000efa:	fd349ae3          	bne	s1,s3,80000ece <procinit+0x6e>
  }
}
    80000efe:	70e2                	ld	ra,56(sp)
    80000f00:	7442                	ld	s0,48(sp)
    80000f02:	74a2                	ld	s1,40(sp)
    80000f04:	7902                	ld	s2,32(sp)
    80000f06:	69e2                	ld	s3,24(sp)
    80000f08:	6a42                	ld	s4,16(sp)
    80000f0a:	6aa2                	ld	s5,8(sp)
    80000f0c:	6b02                	ld	s6,0(sp)
    80000f0e:	6121                	addi	sp,sp,64
    80000f10:	8082                	ret

0000000080000f12 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f18:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f1a:	2501                	sext.w	a0,a0
    80000f1c:	6422                	ld	s0,8(sp)
    80000f1e:	0141                	addi	sp,sp,16
    80000f20:	8082                	ret

0000000080000f22 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
    80000f28:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f2e:	00008517          	auipc	a0,0x8
    80000f32:	ab250513          	addi	a0,a0,-1358 # 800089e0 <cpus>
    80000f36:	953e                	add	a0,a0,a5
    80000f38:	6422                	ld	s0,8(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f3e:	1101                	addi	sp,sp,-32
    80000f40:	ec06                	sd	ra,24(sp)
    80000f42:	e822                	sd	s0,16(sp)
    80000f44:	e426                	sd	s1,8(sp)
    80000f46:	1000                	addi	s0,sp,32
  push_off();
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	3a0080e7          	jalr	928(ra) # 800062e8 <push_off>
    80000f50:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	a5a70713          	addi	a4,a4,-1446 # 800089b0 <pid_lock>
    80000f5e:	97ba                	add	a5,a5,a4
    80000f60:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	426080e7          	jalr	1062(ra) # 80006388 <pop_off>
  return p;
}
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	60e2                	ld	ra,24(sp)
    80000f6e:	6442                	ld	s0,16(sp)
    80000f70:	64a2                	ld	s1,8(sp)
    80000f72:	6105                	addi	sp,sp,32
    80000f74:	8082                	ret

0000000080000f76 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	fc0080e7          	jalr	-64(ra) # 80000f3e <myproc>
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	462080e7          	jalr	1122(ra) # 800063e8 <release>

  if (first) {
    80000f8e:	00008797          	auipc	a5,0x8
    80000f92:	9527a783          	lw	a5,-1710(a5) # 800088e0 <first.1>
    80000f96:	eb89                	bnez	a5,80000fa8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f98:	00001097          	auipc	ra,0x1
    80000f9c:	cde080e7          	jalr	-802(ra) # 80001c76 <usertrapret>
}
    80000fa0:	60a2                	ld	ra,8(sp)
    80000fa2:	6402                	ld	s0,0(sp)
    80000fa4:	0141                	addi	sp,sp,16
    80000fa6:	8082                	ret
    first = 0;
    80000fa8:	00008797          	auipc	a5,0x8
    80000fac:	9207ac23          	sw	zero,-1736(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80000fb0:	4505                	li	a0,1
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	b00080e7          	jalr	-1280(ra) # 80002ab2 <fsinit>
    80000fba:	bff9                	j	80000f98 <forkret+0x22>

0000000080000fbc <allocpid>:
{
    80000fbc:	1101                	addi	sp,sp,-32
    80000fbe:	ec06                	sd	ra,24(sp)
    80000fc0:	e822                	sd	s0,16(sp)
    80000fc2:	e426                	sd	s1,8(sp)
    80000fc4:	e04a                	sd	s2,0(sp)
    80000fc6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fc8:	00008917          	auipc	s2,0x8
    80000fcc:	9e890913          	addi	s2,s2,-1560 # 800089b0 <pid_lock>
    80000fd0:	854a                	mv	a0,s2
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	362080e7          	jalr	866(ra) # 80006334 <acquire>
  pid = nextpid;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	90a78793          	addi	a5,a5,-1782 # 800088e4 <nextpid>
    80000fe2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe4:	0014871b          	addiw	a4,s1,1
    80000fe8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	3fc080e7          	jalr	1020(ra) # 800063e8 <release>
}
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	60e2                	ld	ra,24(sp)
    80000ff8:	6442                	ld	s0,16(sp)
    80000ffa:	64a2                	ld	s1,8(sp)
    80000ffc:	6902                	ld	s2,0(sp)
    80000ffe:	6105                	addi	sp,sp,32
    80001000:	8082                	ret

0000000080001002 <proc_pagetable>:
{
    80001002:	1101                	addi	sp,sp,-32
    80001004:	ec06                	sd	ra,24(sp)
    80001006:	e822                	sd	s0,16(sp)
    80001008:	e426                	sd	s1,8(sp)
    8000100a:	e04a                	sd	s2,0(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	7c0080e7          	jalr	1984(ra) # 800007d0 <uvmcreate>
    80001018:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000101a:	cd39                	beqz	a0,80001078 <proc_pagetable+0x76>
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usyscallpage), PTE_R | PTE_U) < 0) {
    8000101c:	4749                	li	a4,18
    8000101e:	05893683          	ld	a3,88(s2)
    80001022:	6605                	lui	a2,0x1
    80001024:	040005b7          	lui	a1,0x4000
    80001028:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000102a:	05b2                	slli	a1,a1,0xc
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	51a080e7          	jalr	1306(ra) # 80000546 <mappages>
    80001034:	04054963          	bltz	a0,80001086 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001038:	4729                	li	a4,10
    8000103a:	00006697          	auipc	a3,0x6
    8000103e:	fc668693          	addi	a3,a3,-58 # 80007000 <_trampoline>
    80001042:	6605                	lui	a2,0x1
    80001044:	040005b7          	lui	a1,0x4000
    80001048:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104a:	05b2                	slli	a1,a1,0xc
    8000104c:	8526                	mv	a0,s1
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	4f8080e7          	jalr	1272(ra) # 80000546 <mappages>
    80001056:	04054063          	bltz	a0,80001096 <proc_pagetable+0x94>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000105a:	4719                	li	a4,6
    8000105c:	06093683          	ld	a3,96(s2)
    80001060:	6605                	lui	a2,0x1
    80001062:	020005b7          	lui	a1,0x2000
    80001066:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001068:	05b6                	slli	a1,a1,0xd
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	4da080e7          	jalr	1242(ra) # 80000546 <mappages>
    80001074:	02054963          	bltz	a0,800010a6 <proc_pagetable+0xa4>
}
    80001078:	8526                	mv	a0,s1
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret
    uvmfree(pagetable, 0);
    80001086:	4581                	li	a1,0
    80001088:	8526                	mv	a0,s1
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	94c080e7          	jalr	-1716(ra) # 800009d6 <uvmfree>
    return 0;
    80001092:	4481                	li	s1,0
    80001094:	b7d5                	j	80001078 <proc_pagetable+0x76>
    uvmfree(pagetable, 0);
    80001096:	4581                	li	a1,0
    80001098:	8526                	mv	a0,s1
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	93c080e7          	jalr	-1732(ra) # 800009d6 <uvmfree>
    return 0;
    800010a2:	4481                	li	s1,0
    800010a4:	bfd1                	j	80001078 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010a6:	4681                	li	a3,0
    800010a8:	4605                	li	a2,1
    800010aa:	040005b7          	lui	a1,0x4000
    800010ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010b0:	05b2                	slli	a1,a1,0xc
    800010b2:	8526                	mv	a0,s1
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	658080e7          	jalr	1624(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    800010bc:	4581                	li	a1,0
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	916080e7          	jalr	-1770(ra) # 800009d6 <uvmfree>
    return 0;
    800010c8:	4481                	li	s1,0
    800010ca:	b77d                	j	80001078 <proc_pagetable+0x76>

00000000800010cc <proc_freepagetable>:
{
    800010cc:	7179                	addi	sp,sp,-48
    800010ce:	f406                	sd	ra,40(sp)
    800010d0:	f022                	sd	s0,32(sp)
    800010d2:	ec26                	sd	s1,24(sp)
    800010d4:	e84a                	sd	s2,16(sp)
    800010d6:	e44e                	sd	s3,8(sp)
    800010d8:	1800                	addi	s0,sp,48
    800010da:	84aa                	mv	s1,a0
    800010dc:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	04000937          	lui	s2,0x4000
    800010e6:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	620080e7          	jalr	1568(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	020005b7          	lui	a1,0x2000
    800010fc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010fe:	05b6                	slli	a1,a1,0xd
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	60a080e7          	jalr	1546(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000110a:	4681                	li	a3,0
    8000110c:	4605                	li	a2,1
    8000110e:	1975                	addi	s2,s2,-3
    80001110:	00c91593          	slli	a1,s2,0xc
    80001114:	8526                	mv	a0,s1
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	5f6080e7          	jalr	1526(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    8000111e:	85ce                	mv	a1,s3
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	8b4080e7          	jalr	-1868(ra) # 800009d6 <uvmfree>
}
    8000112a:	70a2                	ld	ra,40(sp)
    8000112c:	7402                	ld	s0,32(sp)
    8000112e:	64e2                	ld	s1,24(sp)
    80001130:	6942                	ld	s2,16(sp)
    80001132:	69a2                	ld	s3,8(sp)
    80001134:	6145                	addi	sp,sp,48
    80001136:	8082                	ret

0000000080001138 <freeproc>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	1000                	addi	s0,sp,32
    80001142:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001144:	7128                	ld	a0,96(a0)
    80001146:	c509                	beqz	a0,80001150 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	ed4080e7          	jalr	-300(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001150:	0604b023          	sd	zero,96(s1)
  if(p->usyscallpage)
    80001154:	6ca8                	ld	a0,88(s1)
    80001156:	c509                	beqz	a0,80001160 <freeproc+0x28>
    kfree((void *)p->usyscallpage);
    80001158:	fffff097          	auipc	ra,0xfffff
    8000115c:	ec4080e7          	jalr	-316(ra) # 8000001c <kfree>
  p->usyscallpage = 0;
    80001160:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001164:	68a8                	ld	a0,80(s1)
    80001166:	c511                	beqz	a0,80001172 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    80001168:	64ac                	ld	a1,72(s1)
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	f62080e7          	jalr	-158(ra) # 800010cc <proc_freepagetable>
  p->pagetable = 0;
    80001172:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001176:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000117a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000117e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001182:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001186:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000118a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000118e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001192:	0004ac23          	sw	zero,24(s1)
}
    80001196:	60e2                	ld	ra,24(sp)
    80001198:	6442                	ld	s0,16(sp)
    8000119a:	64a2                	ld	s1,8(sp)
    8000119c:	6105                	addi	sp,sp,32
    8000119e:	8082                	ret

00000000800011a0 <allocproc>:
{
    800011a0:	1101                	addi	sp,sp,-32
    800011a2:	ec06                	sd	ra,24(sp)
    800011a4:	e822                	sd	s0,16(sp)
    800011a6:	e426                	sd	s1,8(sp)
    800011a8:	e04a                	sd	s2,0(sp)
    800011aa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ac:	00008497          	auipc	s1,0x8
    800011b0:	c3448493          	addi	s1,s1,-972 # 80008de0 <proc>
    800011b4:	0000e917          	auipc	s2,0xe
    800011b8:	82c90913          	addi	s2,s2,-2004 # 8000e9e0 <tickslock>
    acquire(&p->lock);
    800011bc:	8526                	mv	a0,s1
    800011be:	00005097          	auipc	ra,0x5
    800011c2:	176080e7          	jalr	374(ra) # 80006334 <acquire>
    if(p->state == UNUSED) {
    800011c6:	4c9c                	lw	a5,24(s1)
    800011c8:	cf81                	beqz	a5,800011e0 <allocproc+0x40>
      release(&p->lock);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00005097          	auipc	ra,0x5
    800011d0:	21c080e7          	jalr	540(ra) # 800063e8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d4:	17048493          	addi	s1,s1,368
    800011d8:	ff2492e3          	bne	s1,s2,800011bc <allocproc+0x1c>
  return 0;
    800011dc:	4481                	li	s1,0
    800011de:	a095                	j	80001242 <allocproc+0xa2>
  p->pid = allocpid();
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	ddc080e7          	jalr	-548(ra) # 80000fbc <allocpid>
    800011e8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011ea:	4785                	li	a5,1
    800011ec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	f2c080e7          	jalr	-212(ra) # 8000011a <kalloc>
    800011f6:	892a                	mv	s2,a0
    800011f8:	f0a8                	sd	a0,96(s1)
    800011fa:	c939                	beqz	a0,80001250 <allocproc+0xb0>
  if ((p->usyscallpage = (struct usyscall *)kalloc()) == 0) {
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	f1e080e7          	jalr	-226(ra) # 8000011a <kalloc>
    80001204:	892a                	mv	s2,a0
    80001206:	eca8                	sd	a0,88(s1)
    80001208:	c125                	beqz	a0,80001268 <allocproc+0xc8>
  p->usyscallpage->pid = p->pid;
    8000120a:	589c                	lw	a5,48(s1)
    8000120c:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	df2080e7          	jalr	-526(ra) # 80001002 <proc_pagetable>
    80001218:	892a                	mv	s2,a0
    8000121a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000121c:	c135                	beqz	a0,80001280 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    8000121e:	07000613          	li	a2,112
    80001222:	4581                	li	a1,0
    80001224:	06848513          	addi	a0,s1,104
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	f52080e7          	jalr	-174(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001230:	00000797          	auipc	a5,0x0
    80001234:	d4678793          	addi	a5,a5,-698 # 80000f76 <forkret>
    80001238:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000123a:	60bc                	ld	a5,64(s1)
    8000123c:	6705                	lui	a4,0x1
    8000123e:	97ba                	add	a5,a5,a4
    80001240:	f8bc                	sd	a5,112(s1)
}
    80001242:	8526                	mv	a0,s1
    80001244:	60e2                	ld	ra,24(sp)
    80001246:	6442                	ld	s0,16(sp)
    80001248:	64a2                	ld	s1,8(sp)
    8000124a:	6902                	ld	s2,0(sp)
    8000124c:	6105                	addi	sp,sp,32
    8000124e:	8082                	ret
    freeproc(p);
    80001250:	8526                	mv	a0,s1
    80001252:	00000097          	auipc	ra,0x0
    80001256:	ee6080e7          	jalr	-282(ra) # 80001138 <freeproc>
    release(&p->lock);
    8000125a:	8526                	mv	a0,s1
    8000125c:	00005097          	auipc	ra,0x5
    80001260:	18c080e7          	jalr	396(ra) # 800063e8 <release>
    return 0;
    80001264:	84ca                	mv	s1,s2
    80001266:	bff1                	j	80001242 <allocproc+0xa2>
    freeproc(p);
    80001268:	8526                	mv	a0,s1
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	ece080e7          	jalr	-306(ra) # 80001138 <freeproc>
    release(&p->lock);
    80001272:	8526                	mv	a0,s1
    80001274:	00005097          	auipc	ra,0x5
    80001278:	174080e7          	jalr	372(ra) # 800063e8 <release>
    return 0;
    8000127c:	84ca                	mv	s1,s2
    8000127e:	b7d1                	j	80001242 <allocproc+0xa2>
    freeproc(p);
    80001280:	8526                	mv	a0,s1
    80001282:	00000097          	auipc	ra,0x0
    80001286:	eb6080e7          	jalr	-330(ra) # 80001138 <freeproc>
    release(&p->lock);
    8000128a:	8526                	mv	a0,s1
    8000128c:	00005097          	auipc	ra,0x5
    80001290:	15c080e7          	jalr	348(ra) # 800063e8 <release>
    return 0;
    80001294:	84ca                	mv	s1,s2
    80001296:	b775                	j	80001242 <allocproc+0xa2>

0000000080001298 <userinit>:
{
    80001298:	1101                	addi	sp,sp,-32
    8000129a:	ec06                	sd	ra,24(sp)
    8000129c:	e822                	sd	s0,16(sp)
    8000129e:	e426                	sd	s1,8(sp)
    800012a0:	1000                	addi	s0,sp,32
  p = allocproc();
    800012a2:	00000097          	auipc	ra,0x0
    800012a6:	efe080e7          	jalr	-258(ra) # 800011a0 <allocproc>
    800012aa:	84aa                	mv	s1,a0
  initproc = p;
    800012ac:	00007797          	auipc	a5,0x7
    800012b0:	6aa7be23          	sd	a0,1724(a5) # 80008968 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012b4:	03400613          	li	a2,52
    800012b8:	00007597          	auipc	a1,0x7
    800012bc:	63858593          	addi	a1,a1,1592 # 800088f0 <initcode>
    800012c0:	6928                	ld	a0,80(a0)
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	53c080e7          	jalr	1340(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    800012ca:	6785                	lui	a5,0x1
    800012cc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012ce:	70b8                	ld	a4,96(s1)
    800012d0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012d4:	70b8                	ld	a4,96(s1)
    800012d6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012d8:	4641                	li	a2,16
    800012da:	00007597          	auipc	a1,0x7
    800012de:	ed658593          	addi	a1,a1,-298 # 800081b0 <etext+0x1b0>
    800012e2:	16048513          	addi	a0,s1,352
    800012e6:	fffff097          	auipc	ra,0xfffff
    800012ea:	fde080e7          	jalr	-34(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800012ee:	00007517          	auipc	a0,0x7
    800012f2:	ed250513          	addi	a0,a0,-302 # 800081c0 <etext+0x1c0>
    800012f6:	00002097          	auipc	ra,0x2
    800012fa:	1e6080e7          	jalr	486(ra) # 800034dc <namei>
    800012fe:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001302:	478d                	li	a5,3
    80001304:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001306:	8526                	mv	a0,s1
    80001308:	00005097          	auipc	ra,0x5
    8000130c:	0e0080e7          	jalr	224(ra) # 800063e8 <release>
}
    80001310:	60e2                	ld	ra,24(sp)
    80001312:	6442                	ld	s0,16(sp)
    80001314:	64a2                	ld	s1,8(sp)
    80001316:	6105                	addi	sp,sp,32
    80001318:	8082                	ret

000000008000131a <growproc>:
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	e04a                	sd	s2,0(sp)
    80001324:	1000                	addi	s0,sp,32
    80001326:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	c16080e7          	jalr	-1002(ra) # 80000f3e <myproc>
    80001330:	84aa                	mv	s1,a0
  sz = p->sz;
    80001332:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001334:	01204c63          	bgtz	s2,8000134c <growproc+0x32>
  } else if(n < 0){
    80001338:	02094663          	bltz	s2,80001364 <growproc+0x4a>
  p->sz = sz;
    8000133c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000133e:	4501                	li	a0,0
}
    80001340:	60e2                	ld	ra,24(sp)
    80001342:	6442                	ld	s0,16(sp)
    80001344:	64a2                	ld	s1,8(sp)
    80001346:	6902                	ld	s2,0(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000134c:	4691                	li	a3,4
    8000134e:	00b90633          	add	a2,s2,a1
    80001352:	6928                	ld	a0,80(a0)
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	564080e7          	jalr	1380(ra) # 800008b8 <uvmalloc>
    8000135c:	85aa                	mv	a1,a0
    8000135e:	fd79                	bnez	a0,8000133c <growproc+0x22>
      return -1;
    80001360:	557d                	li	a0,-1
    80001362:	bff9                	j	80001340 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001364:	00b90633          	add	a2,s2,a1
    80001368:	6928                	ld	a0,80(a0)
    8000136a:	fffff097          	auipc	ra,0xfffff
    8000136e:	506080e7          	jalr	1286(ra) # 80000870 <uvmdealloc>
    80001372:	85aa                	mv	a1,a0
    80001374:	b7e1                	j	8000133c <growproc+0x22>

0000000080001376 <fork>:
{
    80001376:	7139                	addi	sp,sp,-64
    80001378:	fc06                	sd	ra,56(sp)
    8000137a:	f822                	sd	s0,48(sp)
    8000137c:	f426                	sd	s1,40(sp)
    8000137e:	f04a                	sd	s2,32(sp)
    80001380:	ec4e                	sd	s3,24(sp)
    80001382:	e852                	sd	s4,16(sp)
    80001384:	e456                	sd	s5,8(sp)
    80001386:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	bb6080e7          	jalr	-1098(ra) # 80000f3e <myproc>
    80001390:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001392:	00000097          	auipc	ra,0x0
    80001396:	e0e080e7          	jalr	-498(ra) # 800011a0 <allocproc>
    8000139a:	10050c63          	beqz	a0,800014b2 <fork+0x13c>
    8000139e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013a0:	048ab603          	ld	a2,72(s5)
    800013a4:	692c                	ld	a1,80(a0)
    800013a6:	050ab503          	ld	a0,80(s5)
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	666080e7          	jalr	1638(ra) # 80000a10 <uvmcopy>
    800013b2:	04054863          	bltz	a0,80001402 <fork+0x8c>
  np->sz = p->sz;
    800013b6:	048ab783          	ld	a5,72(s5)
    800013ba:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013be:	060ab683          	ld	a3,96(s5)
    800013c2:	87b6                	mv	a5,a3
    800013c4:	060a3703          	ld	a4,96(s4)
    800013c8:	12068693          	addi	a3,a3,288
    800013cc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013d0:	6788                	ld	a0,8(a5)
    800013d2:	6b8c                	ld	a1,16(a5)
    800013d4:	6f90                	ld	a2,24(a5)
    800013d6:	01073023          	sd	a6,0(a4)
    800013da:	e708                	sd	a0,8(a4)
    800013dc:	eb0c                	sd	a1,16(a4)
    800013de:	ef10                	sd	a2,24(a4)
    800013e0:	02078793          	addi	a5,a5,32
    800013e4:	02070713          	addi	a4,a4,32
    800013e8:	fed792e3          	bne	a5,a3,800013cc <fork+0x56>
  np->trapframe->a0 = 0;
    800013ec:	060a3783          	ld	a5,96(s4)
    800013f0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013f4:	0d8a8493          	addi	s1,s5,216
    800013f8:	0d8a0913          	addi	s2,s4,216
    800013fc:	158a8993          	addi	s3,s5,344
    80001400:	a00d                	j	80001422 <fork+0xac>
    freeproc(np);
    80001402:	8552                	mv	a0,s4
    80001404:	00000097          	auipc	ra,0x0
    80001408:	d34080e7          	jalr	-716(ra) # 80001138 <freeproc>
    release(&np->lock);
    8000140c:	8552                	mv	a0,s4
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	fda080e7          	jalr	-38(ra) # 800063e8 <release>
    return -1;
    80001416:	597d                	li	s2,-1
    80001418:	a059                	j	8000149e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000141a:	04a1                	addi	s1,s1,8
    8000141c:	0921                	addi	s2,s2,8
    8000141e:	01348b63          	beq	s1,s3,80001434 <fork+0xbe>
    if(p->ofile[i])
    80001422:	6088                	ld	a0,0(s1)
    80001424:	d97d                	beqz	a0,8000141a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001426:	00002097          	auipc	ra,0x2
    8000142a:	74c080e7          	jalr	1868(ra) # 80003b72 <filedup>
    8000142e:	00a93023          	sd	a0,0(s2)
    80001432:	b7e5                	j	8000141a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001434:	158ab503          	ld	a0,344(s5)
    80001438:	00002097          	auipc	ra,0x2
    8000143c:	8ba080e7          	jalr	-1862(ra) # 80002cf2 <idup>
    80001440:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001444:	4641                	li	a2,16
    80001446:	160a8593          	addi	a1,s5,352
    8000144a:	160a0513          	addi	a0,s4,352
    8000144e:	fffff097          	auipc	ra,0xfffff
    80001452:	e76080e7          	jalr	-394(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001456:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000145a:	8552                	mv	a0,s4
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	f8c080e7          	jalr	-116(ra) # 800063e8 <release>
  acquire(&wait_lock);
    80001464:	00007497          	auipc	s1,0x7
    80001468:	56448493          	addi	s1,s1,1380 # 800089c8 <wait_lock>
    8000146c:	8526                	mv	a0,s1
    8000146e:	00005097          	auipc	ra,0x5
    80001472:	ec6080e7          	jalr	-314(ra) # 80006334 <acquire>
  np->parent = p;
    80001476:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000147a:	8526                	mv	a0,s1
    8000147c:	00005097          	auipc	ra,0x5
    80001480:	f6c080e7          	jalr	-148(ra) # 800063e8 <release>
  acquire(&np->lock);
    80001484:	8552                	mv	a0,s4
    80001486:	00005097          	auipc	ra,0x5
    8000148a:	eae080e7          	jalr	-338(ra) # 80006334 <acquire>
  np->state = RUNNABLE;
    8000148e:	478d                	li	a5,3
    80001490:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001494:	8552                	mv	a0,s4
    80001496:	00005097          	auipc	ra,0x5
    8000149a:	f52080e7          	jalr	-174(ra) # 800063e8 <release>
}
    8000149e:	854a                	mv	a0,s2
    800014a0:	70e2                	ld	ra,56(sp)
    800014a2:	7442                	ld	s0,48(sp)
    800014a4:	74a2                	ld	s1,40(sp)
    800014a6:	7902                	ld	s2,32(sp)
    800014a8:	69e2                	ld	s3,24(sp)
    800014aa:	6a42                	ld	s4,16(sp)
    800014ac:	6aa2                	ld	s5,8(sp)
    800014ae:	6121                	addi	sp,sp,64
    800014b0:	8082                	ret
    return -1;
    800014b2:	597d                	li	s2,-1
    800014b4:	b7ed                	j	8000149e <fork+0x128>

00000000800014b6 <scheduler>:
{
    800014b6:	7139                	addi	sp,sp,-64
    800014b8:	fc06                	sd	ra,56(sp)
    800014ba:	f822                	sd	s0,48(sp)
    800014bc:	f426                	sd	s1,40(sp)
    800014be:	f04a                	sd	s2,32(sp)
    800014c0:	ec4e                	sd	s3,24(sp)
    800014c2:	e852                	sd	s4,16(sp)
    800014c4:	e456                	sd	s5,8(sp)
    800014c6:	e05a                	sd	s6,0(sp)
    800014c8:	0080                	addi	s0,sp,64
    800014ca:	8792                	mv	a5,tp
  int id = r_tp();
    800014cc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014ce:	00779a93          	slli	s5,a5,0x7
    800014d2:	00007717          	auipc	a4,0x7
    800014d6:	4de70713          	addi	a4,a4,1246 # 800089b0 <pid_lock>
    800014da:	9756                	add	a4,a4,s5
    800014dc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014e0:	00007717          	auipc	a4,0x7
    800014e4:	50870713          	addi	a4,a4,1288 # 800089e8 <cpus+0x8>
    800014e8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014ea:	498d                	li	s3,3
        p->state = RUNNING;
    800014ec:	4b11                	li	s6,4
        c->proc = p;
    800014ee:	079e                	slli	a5,a5,0x7
    800014f0:	00007a17          	auipc	s4,0x7
    800014f4:	4c0a0a13          	addi	s4,s4,1216 # 800089b0 <pid_lock>
    800014f8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014fa:	0000d917          	auipc	s2,0xd
    800014fe:	4e690913          	addi	s2,s2,1254 # 8000e9e0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001502:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001506:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000150a:	10079073          	csrw	sstatus,a5
    8000150e:	00008497          	auipc	s1,0x8
    80001512:	8d248493          	addi	s1,s1,-1838 # 80008de0 <proc>
    80001516:	a811                	j	8000152a <scheduler+0x74>
      release(&p->lock);
    80001518:	8526                	mv	a0,s1
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	ece080e7          	jalr	-306(ra) # 800063e8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001522:	17048493          	addi	s1,s1,368
    80001526:	fd248ee3          	beq	s1,s2,80001502 <scheduler+0x4c>
      acquire(&p->lock);
    8000152a:	8526                	mv	a0,s1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	e08080e7          	jalr	-504(ra) # 80006334 <acquire>
      if(p->state == RUNNABLE) {
    80001534:	4c9c                	lw	a5,24(s1)
    80001536:	ff3791e3          	bne	a5,s3,80001518 <scheduler+0x62>
        p->state = RUNNING;
    8000153a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000153e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001542:	06848593          	addi	a1,s1,104
    80001546:	8556                	mv	a0,s5
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	684080e7          	jalr	1668(ra) # 80001bcc <swtch>
        c->proc = 0;
    80001550:	020a3823          	sd	zero,48(s4)
    80001554:	b7d1                	j	80001518 <scheduler+0x62>

0000000080001556 <sched>:
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001564:	00000097          	auipc	ra,0x0
    80001568:	9da080e7          	jalr	-1574(ra) # 80000f3e <myproc>
    8000156c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	d4c080e7          	jalr	-692(ra) # 800062ba <holding>
    80001576:	c93d                	beqz	a0,800015ec <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001578:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000157a:	2781                	sext.w	a5,a5
    8000157c:	079e                	slli	a5,a5,0x7
    8000157e:	00007717          	auipc	a4,0x7
    80001582:	43270713          	addi	a4,a4,1074 # 800089b0 <pid_lock>
    80001586:	97ba                	add	a5,a5,a4
    80001588:	0a87a703          	lw	a4,168(a5)
    8000158c:	4785                	li	a5,1
    8000158e:	06f71763          	bne	a4,a5,800015fc <sched+0xa6>
  if(p->state == RUNNING)
    80001592:	4c98                	lw	a4,24(s1)
    80001594:	4791                	li	a5,4
    80001596:	06f70b63          	beq	a4,a5,8000160c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000159a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000159e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015a0:	efb5                	bnez	a5,8000161c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015a2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015a4:	00007917          	auipc	s2,0x7
    800015a8:	40c90913          	addi	s2,s2,1036 # 800089b0 <pid_lock>
    800015ac:	2781                	sext.w	a5,a5
    800015ae:	079e                	slli	a5,a5,0x7
    800015b0:	97ca                	add	a5,a5,s2
    800015b2:	0ac7a983          	lw	s3,172(a5)
    800015b6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b8:	2781                	sext.w	a5,a5
    800015ba:	079e                	slli	a5,a5,0x7
    800015bc:	00007597          	auipc	a1,0x7
    800015c0:	42c58593          	addi	a1,a1,1068 # 800089e8 <cpus+0x8>
    800015c4:	95be                	add	a1,a1,a5
    800015c6:	06848513          	addi	a0,s1,104
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	602080e7          	jalr	1538(ra) # 80001bcc <swtch>
    800015d2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015d4:	2781                	sext.w	a5,a5
    800015d6:	079e                	slli	a5,a5,0x7
    800015d8:	993e                	add	s2,s2,a5
    800015da:	0b392623          	sw	s3,172(s2)
}
    800015de:	70a2                	ld	ra,40(sp)
    800015e0:	7402                	ld	s0,32(sp)
    800015e2:	64e2                	ld	s1,24(sp)
    800015e4:	6942                	ld	s2,16(sp)
    800015e6:	69a2                	ld	s3,8(sp)
    800015e8:	6145                	addi	sp,sp,48
    800015ea:	8082                	ret
    panic("sched p->lock");
    800015ec:	00007517          	auipc	a0,0x7
    800015f0:	bdc50513          	addi	a0,a0,-1060 # 800081c8 <etext+0x1c8>
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	808080e7          	jalr	-2040(ra) # 80005dfc <panic>
    panic("sched locks");
    800015fc:	00007517          	auipc	a0,0x7
    80001600:	bdc50513          	addi	a0,a0,-1060 # 800081d8 <etext+0x1d8>
    80001604:	00004097          	auipc	ra,0x4
    80001608:	7f8080e7          	jalr	2040(ra) # 80005dfc <panic>
    panic("sched running");
    8000160c:	00007517          	auipc	a0,0x7
    80001610:	bdc50513          	addi	a0,a0,-1060 # 800081e8 <etext+0x1e8>
    80001614:	00004097          	auipc	ra,0x4
    80001618:	7e8080e7          	jalr	2024(ra) # 80005dfc <panic>
    panic("sched interruptible");
    8000161c:	00007517          	auipc	a0,0x7
    80001620:	bdc50513          	addi	a0,a0,-1060 # 800081f8 <etext+0x1f8>
    80001624:	00004097          	auipc	ra,0x4
    80001628:	7d8080e7          	jalr	2008(ra) # 80005dfc <panic>

000000008000162c <yield>:
{
    8000162c:	1101                	addi	sp,sp,-32
    8000162e:	ec06                	sd	ra,24(sp)
    80001630:	e822                	sd	s0,16(sp)
    80001632:	e426                	sd	s1,8(sp)
    80001634:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	908080e7          	jalr	-1784(ra) # 80000f3e <myproc>
    8000163e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001640:	00005097          	auipc	ra,0x5
    80001644:	cf4080e7          	jalr	-780(ra) # 80006334 <acquire>
  p->state = RUNNABLE;
    80001648:	478d                	li	a5,3
    8000164a:	cc9c                	sw	a5,24(s1)
  sched();
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	f0a080e7          	jalr	-246(ra) # 80001556 <sched>
  release(&p->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	d92080e7          	jalr	-622(ra) # 800063e8 <release>
}
    8000165e:	60e2                	ld	ra,24(sp)
    80001660:	6442                	ld	s0,16(sp)
    80001662:	64a2                	ld	s1,8(sp)
    80001664:	6105                	addi	sp,sp,32
    80001666:	8082                	ret

0000000080001668 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001668:	7179                	addi	sp,sp,-48
    8000166a:	f406                	sd	ra,40(sp)
    8000166c:	f022                	sd	s0,32(sp)
    8000166e:	ec26                	sd	s1,24(sp)
    80001670:	e84a                	sd	s2,16(sp)
    80001672:	e44e                	sd	s3,8(sp)
    80001674:	1800                	addi	s0,sp,48
    80001676:	89aa                	mv	s3,a0
    80001678:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	8c4080e7          	jalr	-1852(ra) # 80000f3e <myproc>
    80001682:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	cb0080e7          	jalr	-848(ra) # 80006334 <acquire>
  release(lk);
    8000168c:	854a                	mv	a0,s2
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	d5a080e7          	jalr	-678(ra) # 800063e8 <release>

  // Go to sleep.
  p->chan = chan;
    80001696:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000169a:	4789                	li	a5,2
    8000169c:	cc9c                	sw	a5,24(s1)

  sched();
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	eb8080e7          	jalr	-328(ra) # 80001556 <sched>

  // Tidy up.
  p->chan = 0;
    800016a6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016aa:	8526                	mv	a0,s1
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	d3c080e7          	jalr	-708(ra) # 800063e8 <release>
  acquire(lk);
    800016b4:	854a                	mv	a0,s2
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	c7e080e7          	jalr	-898(ra) # 80006334 <acquire>
}
    800016be:	70a2                	ld	ra,40(sp)
    800016c0:	7402                	ld	s0,32(sp)
    800016c2:	64e2                	ld	s1,24(sp)
    800016c4:	6942                	ld	s2,16(sp)
    800016c6:	69a2                	ld	s3,8(sp)
    800016c8:	6145                	addi	sp,sp,48
    800016ca:	8082                	ret

00000000800016cc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016cc:	7139                	addi	sp,sp,-64
    800016ce:	fc06                	sd	ra,56(sp)
    800016d0:	f822                	sd	s0,48(sp)
    800016d2:	f426                	sd	s1,40(sp)
    800016d4:	f04a                	sd	s2,32(sp)
    800016d6:	ec4e                	sd	s3,24(sp)
    800016d8:	e852                	sd	s4,16(sp)
    800016da:	e456                	sd	s5,8(sp)
    800016dc:	0080                	addi	s0,sp,64
    800016de:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	00007497          	auipc	s1,0x7
    800016e4:	70048493          	addi	s1,s1,1792 # 80008de0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ea:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ec:	0000d917          	auipc	s2,0xd
    800016f0:	2f490913          	addi	s2,s2,756 # 8000e9e0 <tickslock>
    800016f4:	a811                	j	80001708 <wakeup+0x3c>
      }
      release(&p->lock);
    800016f6:	8526                	mv	a0,s1
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	cf0080e7          	jalr	-784(ra) # 800063e8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001700:	17048493          	addi	s1,s1,368
    80001704:	03248663          	beq	s1,s2,80001730 <wakeup+0x64>
    if(p != myproc()){
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	836080e7          	jalr	-1994(ra) # 80000f3e <myproc>
    80001710:	fea488e3          	beq	s1,a0,80001700 <wakeup+0x34>
      acquire(&p->lock);
    80001714:	8526                	mv	a0,s1
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	c1e080e7          	jalr	-994(ra) # 80006334 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000171e:	4c9c                	lw	a5,24(s1)
    80001720:	fd379be3          	bne	a5,s3,800016f6 <wakeup+0x2a>
    80001724:	709c                	ld	a5,32(s1)
    80001726:	fd4798e3          	bne	a5,s4,800016f6 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000172a:	0154ac23          	sw	s5,24(s1)
    8000172e:	b7e1                	j	800016f6 <wakeup+0x2a>
    }
  }
}
    80001730:	70e2                	ld	ra,56(sp)
    80001732:	7442                	ld	s0,48(sp)
    80001734:	74a2                	ld	s1,40(sp)
    80001736:	7902                	ld	s2,32(sp)
    80001738:	69e2                	ld	s3,24(sp)
    8000173a:	6a42                	ld	s4,16(sp)
    8000173c:	6aa2                	ld	s5,8(sp)
    8000173e:	6121                	addi	sp,sp,64
    80001740:	8082                	ret

0000000080001742 <reparent>:
{
    80001742:	7179                	addi	sp,sp,-48
    80001744:	f406                	sd	ra,40(sp)
    80001746:	f022                	sd	s0,32(sp)
    80001748:	ec26                	sd	s1,24(sp)
    8000174a:	e84a                	sd	s2,16(sp)
    8000174c:	e44e                	sd	s3,8(sp)
    8000174e:	e052                	sd	s4,0(sp)
    80001750:	1800                	addi	s0,sp,48
    80001752:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001754:	00007497          	auipc	s1,0x7
    80001758:	68c48493          	addi	s1,s1,1676 # 80008de0 <proc>
      pp->parent = initproc;
    8000175c:	00007a17          	auipc	s4,0x7
    80001760:	20ca0a13          	addi	s4,s4,524 # 80008968 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001764:	0000d997          	auipc	s3,0xd
    80001768:	27c98993          	addi	s3,s3,636 # 8000e9e0 <tickslock>
    8000176c:	a029                	j	80001776 <reparent+0x34>
    8000176e:	17048493          	addi	s1,s1,368
    80001772:	01348d63          	beq	s1,s3,8000178c <reparent+0x4a>
    if(pp->parent == p){
    80001776:	7c9c                	ld	a5,56(s1)
    80001778:	ff279be3          	bne	a5,s2,8000176e <reparent+0x2c>
      pp->parent = initproc;
    8000177c:	000a3503          	ld	a0,0(s4)
    80001780:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001782:	00000097          	auipc	ra,0x0
    80001786:	f4a080e7          	jalr	-182(ra) # 800016cc <wakeup>
    8000178a:	b7d5                	j	8000176e <reparent+0x2c>
}
    8000178c:	70a2                	ld	ra,40(sp)
    8000178e:	7402                	ld	s0,32(sp)
    80001790:	64e2                	ld	s1,24(sp)
    80001792:	6942                	ld	s2,16(sp)
    80001794:	69a2                	ld	s3,8(sp)
    80001796:	6a02                	ld	s4,0(sp)
    80001798:	6145                	addi	sp,sp,48
    8000179a:	8082                	ret

000000008000179c <exit>:
{
    8000179c:	7179                	addi	sp,sp,-48
    8000179e:	f406                	sd	ra,40(sp)
    800017a0:	f022                	sd	s0,32(sp)
    800017a2:	ec26                	sd	s1,24(sp)
    800017a4:	e84a                	sd	s2,16(sp)
    800017a6:	e44e                	sd	s3,8(sp)
    800017a8:	e052                	sd	s4,0(sp)
    800017aa:	1800                	addi	s0,sp,48
    800017ac:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ae:	fffff097          	auipc	ra,0xfffff
    800017b2:	790080e7          	jalr	1936(ra) # 80000f3e <myproc>
    800017b6:	89aa                	mv	s3,a0
  if(p == initproc)
    800017b8:	00007797          	auipc	a5,0x7
    800017bc:	1b07b783          	ld	a5,432(a5) # 80008968 <initproc>
    800017c0:	0d850493          	addi	s1,a0,216
    800017c4:	15850913          	addi	s2,a0,344
    800017c8:	02a79363          	bne	a5,a0,800017ee <exit+0x52>
    panic("init exiting");
    800017cc:	00007517          	auipc	a0,0x7
    800017d0:	a4450513          	addi	a0,a0,-1468 # 80008210 <etext+0x210>
    800017d4:	00004097          	auipc	ra,0x4
    800017d8:	628080e7          	jalr	1576(ra) # 80005dfc <panic>
      fileclose(f);
    800017dc:	00002097          	auipc	ra,0x2
    800017e0:	3e8080e7          	jalr	1000(ra) # 80003bc4 <fileclose>
      p->ofile[fd] = 0;
    800017e4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017e8:	04a1                	addi	s1,s1,8
    800017ea:	01248563          	beq	s1,s2,800017f4 <exit+0x58>
    if(p->ofile[fd]){
    800017ee:	6088                	ld	a0,0(s1)
    800017f0:	f575                	bnez	a0,800017dc <exit+0x40>
    800017f2:	bfdd                	j	800017e8 <exit+0x4c>
  begin_op();
    800017f4:	00002097          	auipc	ra,0x2
    800017f8:	f08080e7          	jalr	-248(ra) # 800036fc <begin_op>
  iput(p->cwd);
    800017fc:	1589b503          	ld	a0,344(s3)
    80001800:	00001097          	auipc	ra,0x1
    80001804:	6ea080e7          	jalr	1770(ra) # 80002eea <iput>
  end_op();
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	f72080e7          	jalr	-142(ra) # 8000377a <end_op>
  p->cwd = 0;
    80001810:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001814:	00007497          	auipc	s1,0x7
    80001818:	1b448493          	addi	s1,s1,436 # 800089c8 <wait_lock>
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	b16080e7          	jalr	-1258(ra) # 80006334 <acquire>
  reparent(p);
    80001826:	854e                	mv	a0,s3
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	f1a080e7          	jalr	-230(ra) # 80001742 <reparent>
  wakeup(p->parent);
    80001830:	0389b503          	ld	a0,56(s3)
    80001834:	00000097          	auipc	ra,0x0
    80001838:	e98080e7          	jalr	-360(ra) # 800016cc <wakeup>
  acquire(&p->lock);
    8000183c:	854e                	mv	a0,s3
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	af6080e7          	jalr	-1290(ra) # 80006334 <acquire>
  p->xstate = status;
    80001846:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000184a:	4795                	li	a5,5
    8000184c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001850:	8526                	mv	a0,s1
    80001852:	00005097          	auipc	ra,0x5
    80001856:	b96080e7          	jalr	-1130(ra) # 800063e8 <release>
  sched();
    8000185a:	00000097          	auipc	ra,0x0
    8000185e:	cfc080e7          	jalr	-772(ra) # 80001556 <sched>
  panic("zombie exit");
    80001862:	00007517          	auipc	a0,0x7
    80001866:	9be50513          	addi	a0,a0,-1602 # 80008220 <etext+0x220>
    8000186a:	00004097          	auipc	ra,0x4
    8000186e:	592080e7          	jalr	1426(ra) # 80005dfc <panic>

0000000080001872 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001872:	7179                	addi	sp,sp,-48
    80001874:	f406                	sd	ra,40(sp)
    80001876:	f022                	sd	s0,32(sp)
    80001878:	ec26                	sd	s1,24(sp)
    8000187a:	e84a                	sd	s2,16(sp)
    8000187c:	e44e                	sd	s3,8(sp)
    8000187e:	1800                	addi	s0,sp,48
    80001880:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001882:	00007497          	auipc	s1,0x7
    80001886:	55e48493          	addi	s1,s1,1374 # 80008de0 <proc>
    8000188a:	0000d997          	auipc	s3,0xd
    8000188e:	15698993          	addi	s3,s3,342 # 8000e9e0 <tickslock>
    acquire(&p->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	aa0080e7          	jalr	-1376(ra) # 80006334 <acquire>
    if(p->pid == pid){
    8000189c:	589c                	lw	a5,48(s1)
    8000189e:	01278d63          	beq	a5,s2,800018b8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018a2:	8526                	mv	a0,s1
    800018a4:	00005097          	auipc	ra,0x5
    800018a8:	b44080e7          	jalr	-1212(ra) # 800063e8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ac:	17048493          	addi	s1,s1,368
    800018b0:	ff3491e3          	bne	s1,s3,80001892 <kill+0x20>
  }
  return -1;
    800018b4:	557d                	li	a0,-1
    800018b6:	a829                	j	800018d0 <kill+0x5e>
      p->killed = 1;
    800018b8:	4785                	li	a5,1
    800018ba:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018bc:	4c98                	lw	a4,24(s1)
    800018be:	4789                	li	a5,2
    800018c0:	00f70f63          	beq	a4,a5,800018de <kill+0x6c>
      release(&p->lock);
    800018c4:	8526                	mv	a0,s1
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	b22080e7          	jalr	-1246(ra) # 800063e8 <release>
      return 0;
    800018ce:	4501                	li	a0,0
}
    800018d0:	70a2                	ld	ra,40(sp)
    800018d2:	7402                	ld	s0,32(sp)
    800018d4:	64e2                	ld	s1,24(sp)
    800018d6:	6942                	ld	s2,16(sp)
    800018d8:	69a2                	ld	s3,8(sp)
    800018da:	6145                	addi	sp,sp,48
    800018dc:	8082                	ret
        p->state = RUNNABLE;
    800018de:	478d                	li	a5,3
    800018e0:	cc9c                	sw	a5,24(s1)
    800018e2:	b7cd                	j	800018c4 <kill+0x52>

00000000800018e4 <setkilled>:

void
setkilled(struct proc *p)
{
    800018e4:	1101                	addi	sp,sp,-32
    800018e6:	ec06                	sd	ra,24(sp)
    800018e8:	e822                	sd	s0,16(sp)
    800018ea:	e426                	sd	s1,8(sp)
    800018ec:	1000                	addi	s0,sp,32
    800018ee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a44080e7          	jalr	-1468(ra) # 80006334 <acquire>
  p->killed = 1;
    800018f8:	4785                	li	a5,1
    800018fa:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800018fc:	8526                	mv	a0,s1
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	aea080e7          	jalr	-1302(ra) # 800063e8 <release>
}
    80001906:	60e2                	ld	ra,24(sp)
    80001908:	6442                	ld	s0,16(sp)
    8000190a:	64a2                	ld	s1,8(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <killed>:

int
killed(struct proc *p)
{
    80001910:	1101                	addi	sp,sp,-32
    80001912:	ec06                	sd	ra,24(sp)
    80001914:	e822                	sd	s0,16(sp)
    80001916:	e426                	sd	s1,8(sp)
    80001918:	e04a                	sd	s2,0(sp)
    8000191a:	1000                	addi	s0,sp,32
    8000191c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	a16080e7          	jalr	-1514(ra) # 80006334 <acquire>
  k = p->killed;
    80001926:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	abc080e7          	jalr	-1348(ra) # 800063e8 <release>
  return k;
}
    80001934:	854a                	mv	a0,s2
    80001936:	60e2                	ld	ra,24(sp)
    80001938:	6442                	ld	s0,16(sp)
    8000193a:	64a2                	ld	s1,8(sp)
    8000193c:	6902                	ld	s2,0(sp)
    8000193e:	6105                	addi	sp,sp,32
    80001940:	8082                	ret

0000000080001942 <wait>:
{
    80001942:	715d                	addi	sp,sp,-80
    80001944:	e486                	sd	ra,72(sp)
    80001946:	e0a2                	sd	s0,64(sp)
    80001948:	fc26                	sd	s1,56(sp)
    8000194a:	f84a                	sd	s2,48(sp)
    8000194c:	f44e                	sd	s3,40(sp)
    8000194e:	f052                	sd	s4,32(sp)
    80001950:	ec56                	sd	s5,24(sp)
    80001952:	e85a                	sd	s6,16(sp)
    80001954:	e45e                	sd	s7,8(sp)
    80001956:	e062                	sd	s8,0(sp)
    80001958:	0880                	addi	s0,sp,80
    8000195a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	5e2080e7          	jalr	1506(ra) # 80000f3e <myproc>
    80001964:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001966:	00007517          	auipc	a0,0x7
    8000196a:	06250513          	addi	a0,a0,98 # 800089c8 <wait_lock>
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	9c6080e7          	jalr	-1594(ra) # 80006334 <acquire>
    havekids = 0;
    80001976:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001978:	4a15                	li	s4,5
        havekids = 1;
    8000197a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000197c:	0000d997          	auipc	s3,0xd
    80001980:	06498993          	addi	s3,s3,100 # 8000e9e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001984:	00007c17          	auipc	s8,0x7
    80001988:	044c0c13          	addi	s8,s8,68 # 800089c8 <wait_lock>
    havekids = 0;
    8000198c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000198e:	00007497          	auipc	s1,0x7
    80001992:	45248493          	addi	s1,s1,1106 # 80008de0 <proc>
    80001996:	a0bd                	j	80001a04 <wait+0xc2>
          pid = pp->pid;
    80001998:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000199c:	000b0e63          	beqz	s6,800019b8 <wait+0x76>
    800019a0:	4691                	li	a3,4
    800019a2:	02c48613          	addi	a2,s1,44
    800019a6:	85da                	mv	a1,s6
    800019a8:	05093503          	ld	a0,80(s2)
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	168080e7          	jalr	360(ra) # 80000b14 <copyout>
    800019b4:	02054563          	bltz	a0,800019de <wait+0x9c>
          freeproc(pp);
    800019b8:	8526                	mv	a0,s1
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	77e080e7          	jalr	1918(ra) # 80001138 <freeproc>
          release(&pp->lock);
    800019c2:	8526                	mv	a0,s1
    800019c4:	00005097          	auipc	ra,0x5
    800019c8:	a24080e7          	jalr	-1500(ra) # 800063e8 <release>
          release(&wait_lock);
    800019cc:	00007517          	auipc	a0,0x7
    800019d0:	ffc50513          	addi	a0,a0,-4 # 800089c8 <wait_lock>
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	a14080e7          	jalr	-1516(ra) # 800063e8 <release>
          return pid;
    800019dc:	a0b5                	j	80001a48 <wait+0x106>
            release(&pp->lock);
    800019de:	8526                	mv	a0,s1
    800019e0:	00005097          	auipc	ra,0x5
    800019e4:	a08080e7          	jalr	-1528(ra) # 800063e8 <release>
            release(&wait_lock);
    800019e8:	00007517          	auipc	a0,0x7
    800019ec:	fe050513          	addi	a0,a0,-32 # 800089c8 <wait_lock>
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	9f8080e7          	jalr	-1544(ra) # 800063e8 <release>
            return -1;
    800019f8:	59fd                	li	s3,-1
    800019fa:	a0b9                	j	80001a48 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019fc:	17048493          	addi	s1,s1,368
    80001a00:	03348463          	beq	s1,s3,80001a28 <wait+0xe6>
      if(pp->parent == p){
    80001a04:	7c9c                	ld	a5,56(s1)
    80001a06:	ff279be3          	bne	a5,s2,800019fc <wait+0xba>
        acquire(&pp->lock);
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	00005097          	auipc	ra,0x5
    80001a10:	928080e7          	jalr	-1752(ra) # 80006334 <acquire>
        if(pp->state == ZOMBIE){
    80001a14:	4c9c                	lw	a5,24(s1)
    80001a16:	f94781e3          	beq	a5,s4,80001998 <wait+0x56>
        release(&pp->lock);
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	00005097          	auipc	ra,0x5
    80001a20:	9cc080e7          	jalr	-1588(ra) # 800063e8 <release>
        havekids = 1;
    80001a24:	8756                	mv	a4,s5
    80001a26:	bfd9                	j	800019fc <wait+0xba>
    if(!havekids || killed(p)){
    80001a28:	c719                	beqz	a4,80001a36 <wait+0xf4>
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	00000097          	auipc	ra,0x0
    80001a30:	ee4080e7          	jalr	-284(ra) # 80001910 <killed>
    80001a34:	c51d                	beqz	a0,80001a62 <wait+0x120>
      release(&wait_lock);
    80001a36:	00007517          	auipc	a0,0x7
    80001a3a:	f9250513          	addi	a0,a0,-110 # 800089c8 <wait_lock>
    80001a3e:	00005097          	auipc	ra,0x5
    80001a42:	9aa080e7          	jalr	-1622(ra) # 800063e8 <release>
      return -1;
    80001a46:	59fd                	li	s3,-1
}
    80001a48:	854e                	mv	a0,s3
    80001a4a:	60a6                	ld	ra,72(sp)
    80001a4c:	6406                	ld	s0,64(sp)
    80001a4e:	74e2                	ld	s1,56(sp)
    80001a50:	7942                	ld	s2,48(sp)
    80001a52:	79a2                	ld	s3,40(sp)
    80001a54:	7a02                	ld	s4,32(sp)
    80001a56:	6ae2                	ld	s5,24(sp)
    80001a58:	6b42                	ld	s6,16(sp)
    80001a5a:	6ba2                	ld	s7,8(sp)
    80001a5c:	6c02                	ld	s8,0(sp)
    80001a5e:	6161                	addi	sp,sp,80
    80001a60:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a62:	85e2                	mv	a1,s8
    80001a64:	854a                	mv	a0,s2
    80001a66:	00000097          	auipc	ra,0x0
    80001a6a:	c02080e7          	jalr	-1022(ra) # 80001668 <sleep>
    havekids = 0;
    80001a6e:	bf39                	j	8000198c <wait+0x4a>

0000000080001a70 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a70:	7179                	addi	sp,sp,-48
    80001a72:	f406                	sd	ra,40(sp)
    80001a74:	f022                	sd	s0,32(sp)
    80001a76:	ec26                	sd	s1,24(sp)
    80001a78:	e84a                	sd	s2,16(sp)
    80001a7a:	e44e                	sd	s3,8(sp)
    80001a7c:	e052                	sd	s4,0(sp)
    80001a7e:	1800                	addi	s0,sp,48
    80001a80:	84aa                	mv	s1,a0
    80001a82:	892e                	mv	s2,a1
    80001a84:	89b2                	mv	s3,a2
    80001a86:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	4b6080e7          	jalr	1206(ra) # 80000f3e <myproc>
  if(user_dst){
    80001a90:	c08d                	beqz	s1,80001ab2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a92:	86d2                	mv	a3,s4
    80001a94:	864e                	mv	a2,s3
    80001a96:	85ca                	mv	a1,s2
    80001a98:	6928                	ld	a0,80(a0)
    80001a9a:	fffff097          	auipc	ra,0xfffff
    80001a9e:	07a080e7          	jalr	122(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa2:	70a2                	ld	ra,40(sp)
    80001aa4:	7402                	ld	s0,32(sp)
    80001aa6:	64e2                	ld	s1,24(sp)
    80001aa8:	6942                	ld	s2,16(sp)
    80001aaa:	69a2                	ld	s3,8(sp)
    80001aac:	6a02                	ld	s4,0(sp)
    80001aae:	6145                	addi	sp,sp,48
    80001ab0:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab2:	000a061b          	sext.w	a2,s4
    80001ab6:	85ce                	mv	a1,s3
    80001ab8:	854a                	mv	a0,s2
    80001aba:	ffffe097          	auipc	ra,0xffffe
    80001abe:	71c080e7          	jalr	1820(ra) # 800001d6 <memmove>
    return 0;
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	bff9                	j	80001aa2 <either_copyout+0x32>

0000000080001ac6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ac6:	7179                	addi	sp,sp,-48
    80001ac8:	f406                	sd	ra,40(sp)
    80001aca:	f022                	sd	s0,32(sp)
    80001acc:	ec26                	sd	s1,24(sp)
    80001ace:	e84a                	sd	s2,16(sp)
    80001ad0:	e44e                	sd	s3,8(sp)
    80001ad2:	e052                	sd	s4,0(sp)
    80001ad4:	1800                	addi	s0,sp,48
    80001ad6:	892a                	mv	s2,a0
    80001ad8:	84ae                	mv	s1,a1
    80001ada:	89b2                	mv	s3,a2
    80001adc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ade:	fffff097          	auipc	ra,0xfffff
    80001ae2:	460080e7          	jalr	1120(ra) # 80000f3e <myproc>
  if(user_src){
    80001ae6:	c08d                	beqz	s1,80001b08 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ae8:	86d2                	mv	a3,s4
    80001aea:	864e                	mv	a2,s3
    80001aec:	85ca                	mv	a1,s2
    80001aee:	6928                	ld	a0,80(a0)
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	0b0080e7          	jalr	176(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001af8:	70a2                	ld	ra,40(sp)
    80001afa:	7402                	ld	s0,32(sp)
    80001afc:	64e2                	ld	s1,24(sp)
    80001afe:	6942                	ld	s2,16(sp)
    80001b00:	69a2                	ld	s3,8(sp)
    80001b02:	6a02                	ld	s4,0(sp)
    80001b04:	6145                	addi	sp,sp,48
    80001b06:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b08:	000a061b          	sext.w	a2,s4
    80001b0c:	85ce                	mv	a1,s3
    80001b0e:	854a                	mv	a0,s2
    80001b10:	ffffe097          	auipc	ra,0xffffe
    80001b14:	6c6080e7          	jalr	1734(ra) # 800001d6 <memmove>
    return 0;
    80001b18:	8526                	mv	a0,s1
    80001b1a:	bff9                	j	80001af8 <either_copyin+0x32>

0000000080001b1c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b1c:	715d                	addi	sp,sp,-80
    80001b1e:	e486                	sd	ra,72(sp)
    80001b20:	e0a2                	sd	s0,64(sp)
    80001b22:	fc26                	sd	s1,56(sp)
    80001b24:	f84a                	sd	s2,48(sp)
    80001b26:	f44e                	sd	s3,40(sp)
    80001b28:	f052                	sd	s4,32(sp)
    80001b2a:	ec56                	sd	s5,24(sp)
    80001b2c:	e85a                	sd	s6,16(sp)
    80001b2e:	e45e                	sd	s7,8(sp)
    80001b30:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b32:	00006517          	auipc	a0,0x6
    80001b36:	51650513          	addi	a0,a0,1302 # 80008048 <etext+0x48>
    80001b3a:	00004097          	auipc	ra,0x4
    80001b3e:	30c080e7          	jalr	780(ra) # 80005e46 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b42:	00007497          	auipc	s1,0x7
    80001b46:	3fe48493          	addi	s1,s1,1022 # 80008f40 <proc+0x160>
    80001b4a:	0000d917          	auipc	s2,0xd
    80001b4e:	ff690913          	addi	s2,s2,-10 # 8000eb40 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b52:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b54:	00006997          	auipc	s3,0x6
    80001b58:	6dc98993          	addi	s3,s3,1756 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b5c:	00006a97          	auipc	s5,0x6
    80001b60:	6dca8a93          	addi	s5,s5,1756 # 80008238 <etext+0x238>
    printf("\n");
    80001b64:	00006a17          	auipc	s4,0x6
    80001b68:	4e4a0a13          	addi	s4,s4,1252 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b6c:	00006b97          	auipc	s7,0x6
    80001b70:	70cb8b93          	addi	s7,s7,1804 # 80008278 <states.0>
    80001b74:	a00d                	j	80001b96 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b76:	ed06a583          	lw	a1,-304(a3)
    80001b7a:	8556                	mv	a0,s5
    80001b7c:	00004097          	auipc	ra,0x4
    80001b80:	2ca080e7          	jalr	714(ra) # 80005e46 <printf>
    printf("\n");
    80001b84:	8552                	mv	a0,s4
    80001b86:	00004097          	auipc	ra,0x4
    80001b8a:	2c0080e7          	jalr	704(ra) # 80005e46 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b8e:	17048493          	addi	s1,s1,368
    80001b92:	03248263          	beq	s1,s2,80001bb6 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b96:	86a6                	mv	a3,s1
    80001b98:	eb84a783          	lw	a5,-328(s1)
    80001b9c:	dbed                	beqz	a5,80001b8e <procdump+0x72>
      state = "???";
    80001b9e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba0:	fcfb6be3          	bltu	s6,a5,80001b76 <procdump+0x5a>
    80001ba4:	02079713          	slli	a4,a5,0x20
    80001ba8:	01d75793          	srli	a5,a4,0x1d
    80001bac:	97de                	add	a5,a5,s7
    80001bae:	6390                	ld	a2,0(a5)
    80001bb0:	f279                	bnez	a2,80001b76 <procdump+0x5a>
      state = "???";
    80001bb2:	864e                	mv	a2,s3
    80001bb4:	b7c9                	j	80001b76 <procdump+0x5a>
  }
}
    80001bb6:	60a6                	ld	ra,72(sp)
    80001bb8:	6406                	ld	s0,64(sp)
    80001bba:	74e2                	ld	s1,56(sp)
    80001bbc:	7942                	ld	s2,48(sp)
    80001bbe:	79a2                	ld	s3,40(sp)
    80001bc0:	7a02                	ld	s4,32(sp)
    80001bc2:	6ae2                	ld	s5,24(sp)
    80001bc4:	6b42                	ld	s6,16(sp)
    80001bc6:	6ba2                	ld	s7,8(sp)
    80001bc8:	6161                	addi	sp,sp,80
    80001bca:	8082                	ret

0000000080001bcc <swtch>:
    80001bcc:	00153023          	sd	ra,0(a0)
    80001bd0:	00253423          	sd	sp,8(a0)
    80001bd4:	e900                	sd	s0,16(a0)
    80001bd6:	ed04                	sd	s1,24(a0)
    80001bd8:	03253023          	sd	s2,32(a0)
    80001bdc:	03353423          	sd	s3,40(a0)
    80001be0:	03453823          	sd	s4,48(a0)
    80001be4:	03553c23          	sd	s5,56(a0)
    80001be8:	05653023          	sd	s6,64(a0)
    80001bec:	05753423          	sd	s7,72(a0)
    80001bf0:	05853823          	sd	s8,80(a0)
    80001bf4:	05953c23          	sd	s9,88(a0)
    80001bf8:	07a53023          	sd	s10,96(a0)
    80001bfc:	07b53423          	sd	s11,104(a0)
    80001c00:	0005b083          	ld	ra,0(a1)
    80001c04:	0085b103          	ld	sp,8(a1)
    80001c08:	6980                	ld	s0,16(a1)
    80001c0a:	6d84                	ld	s1,24(a1)
    80001c0c:	0205b903          	ld	s2,32(a1)
    80001c10:	0285b983          	ld	s3,40(a1)
    80001c14:	0305ba03          	ld	s4,48(a1)
    80001c18:	0385ba83          	ld	s5,56(a1)
    80001c1c:	0405bb03          	ld	s6,64(a1)
    80001c20:	0485bb83          	ld	s7,72(a1)
    80001c24:	0505bc03          	ld	s8,80(a1)
    80001c28:	0585bc83          	ld	s9,88(a1)
    80001c2c:	0605bd03          	ld	s10,96(a1)
    80001c30:	0685bd83          	ld	s11,104(a1)
    80001c34:	8082                	ret

0000000080001c36 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c36:	1141                	addi	sp,sp,-16
    80001c38:	e406                	sd	ra,8(sp)
    80001c3a:	e022                	sd	s0,0(sp)
    80001c3c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c3e:	00006597          	auipc	a1,0x6
    80001c42:	66a58593          	addi	a1,a1,1642 # 800082a8 <states.0+0x30>
    80001c46:	0000d517          	auipc	a0,0xd
    80001c4a:	d9a50513          	addi	a0,a0,-614 # 8000e9e0 <tickslock>
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	656080e7          	jalr	1622(ra) # 800062a4 <initlock>
}
    80001c56:	60a2                	ld	ra,8(sp)
    80001c58:	6402                	ld	s0,0(sp)
    80001c5a:	0141                	addi	sp,sp,16
    80001c5c:	8082                	ret

0000000080001c5e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c5e:	1141                	addi	sp,sp,-16
    80001c60:	e422                	sd	s0,8(sp)
    80001c62:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c64:	00003797          	auipc	a5,0x3
    80001c68:	5cc78793          	addi	a5,a5,1484 # 80005230 <kernelvec>
    80001c6c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c70:	6422                	ld	s0,8(sp)
    80001c72:	0141                	addi	sp,sp,16
    80001c74:	8082                	ret

0000000080001c76 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c76:	1141                	addi	sp,sp,-16
    80001c78:	e406                	sd	ra,8(sp)
    80001c7a:	e022                	sd	s0,0(sp)
    80001c7c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	2c0080e7          	jalr	704(ra) # 80000f3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c86:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c8a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c90:	00005697          	auipc	a3,0x5
    80001c94:	37068693          	addi	a3,a3,880 # 80007000 <_trampoline>
    80001c98:	00005717          	auipc	a4,0x5
    80001c9c:	36870713          	addi	a4,a4,872 # 80007000 <_trampoline>
    80001ca0:	8f15                	sub	a4,a4,a3
    80001ca2:	040007b7          	lui	a5,0x4000
    80001ca6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ca8:	07b2                	slli	a5,a5,0xc
    80001caa:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cac:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cb0:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cb2:	18002673          	csrr	a2,satp
    80001cb6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cb8:	7130                	ld	a2,96(a0)
    80001cba:	6138                	ld	a4,64(a0)
    80001cbc:	6585                	lui	a1,0x1
    80001cbe:	972e                	add	a4,a4,a1
    80001cc0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cc2:	7138                	ld	a4,96(a0)
    80001cc4:	00000617          	auipc	a2,0x0
    80001cc8:	13060613          	addi	a2,a2,304 # 80001df4 <usertrap>
    80001ccc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cce:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cd0:	8612                	mv	a2,tp
    80001cd2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cd8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cdc:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce4:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ce6:	6f18                	ld	a4,24(a4)
    80001ce8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cec:	6928                	ld	a0,80(a0)
    80001cee:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001cf0:	00005717          	auipc	a4,0x5
    80001cf4:	3ac70713          	addi	a4,a4,940 # 8000709c <userret>
    80001cf8:	8f15                	sub	a4,a4,a3
    80001cfa:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001cfc:	577d                	li	a4,-1
    80001cfe:	177e                	slli	a4,a4,0x3f
    80001d00:	8d59                	or	a0,a0,a4
    80001d02:	9782                	jalr	a5
}
    80001d04:	60a2                	ld	ra,8(sp)
    80001d06:	6402                	ld	s0,0(sp)
    80001d08:	0141                	addi	sp,sp,16
    80001d0a:	8082                	ret

0000000080001d0c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d0c:	1101                	addi	sp,sp,-32
    80001d0e:	ec06                	sd	ra,24(sp)
    80001d10:	e822                	sd	s0,16(sp)
    80001d12:	e426                	sd	s1,8(sp)
    80001d14:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d16:	0000d497          	auipc	s1,0xd
    80001d1a:	cca48493          	addi	s1,s1,-822 # 8000e9e0 <tickslock>
    80001d1e:	8526                	mv	a0,s1
    80001d20:	00004097          	auipc	ra,0x4
    80001d24:	614080e7          	jalr	1556(ra) # 80006334 <acquire>
  ticks++;
    80001d28:	00007517          	auipc	a0,0x7
    80001d2c:	c4850513          	addi	a0,a0,-952 # 80008970 <ticks>
    80001d30:	411c                	lw	a5,0(a0)
    80001d32:	2785                	addiw	a5,a5,1
    80001d34:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	996080e7          	jalr	-1642(ra) # 800016cc <wakeup>
  release(&tickslock);
    80001d3e:	8526                	mv	a0,s1
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	6a8080e7          	jalr	1704(ra) # 800063e8 <release>
}
    80001d48:	60e2                	ld	ra,24(sp)
    80001d4a:	6442                	ld	s0,16(sp)
    80001d4c:	64a2                	ld	s1,8(sp)
    80001d4e:	6105                	addi	sp,sp,32
    80001d50:	8082                	ret

0000000080001d52 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d52:	1101                	addi	sp,sp,-32
    80001d54:	ec06                	sd	ra,24(sp)
    80001d56:	e822                	sd	s0,16(sp)
    80001d58:	e426                	sd	s1,8(sp)
    80001d5a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d60:	00074d63          	bltz	a4,80001d7a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d64:	57fd                	li	a5,-1
    80001d66:	17fe                	slli	a5,a5,0x3f
    80001d68:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d6a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d6c:	06f70363          	beq	a4,a5,80001dd2 <devintr+0x80>
  }
}
    80001d70:	60e2                	ld	ra,24(sp)
    80001d72:	6442                	ld	s0,16(sp)
    80001d74:	64a2                	ld	s1,8(sp)
    80001d76:	6105                	addi	sp,sp,32
    80001d78:	8082                	ret
     (scause & 0xff) == 9){
    80001d7a:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d7e:	46a5                	li	a3,9
    80001d80:	fed792e3          	bne	a5,a3,80001d64 <devintr+0x12>
    int irq = plic_claim();
    80001d84:	00003097          	auipc	ra,0x3
    80001d88:	5b4080e7          	jalr	1460(ra) # 80005338 <plic_claim>
    80001d8c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d8e:	47a9                	li	a5,10
    80001d90:	02f50763          	beq	a0,a5,80001dbe <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d94:	4785                	li	a5,1
    80001d96:	02f50963          	beq	a0,a5,80001dc8 <devintr+0x76>
    return 1;
    80001d9a:	4505                	li	a0,1
    } else if(irq){
    80001d9c:	d8f1                	beqz	s1,80001d70 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d9e:	85a6                	mv	a1,s1
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	51050513          	addi	a0,a0,1296 # 800082b0 <states.0+0x38>
    80001da8:	00004097          	auipc	ra,0x4
    80001dac:	09e080e7          	jalr	158(ra) # 80005e46 <printf>
      plic_complete(irq);
    80001db0:	8526                	mv	a0,s1
    80001db2:	00003097          	auipc	ra,0x3
    80001db6:	5aa080e7          	jalr	1450(ra) # 8000535c <plic_complete>
    return 1;
    80001dba:	4505                	li	a0,1
    80001dbc:	bf55                	j	80001d70 <devintr+0x1e>
      uartintr();
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	496080e7          	jalr	1174(ra) # 80006254 <uartintr>
    80001dc6:	b7ed                	j	80001db0 <devintr+0x5e>
      virtio_disk_intr();
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	a5c080e7          	jalr	-1444(ra) # 80005824 <virtio_disk_intr>
    80001dd0:	b7c5                	j	80001db0 <devintr+0x5e>
    if(cpuid() == 0){
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	140080e7          	jalr	320(ra) # 80000f12 <cpuid>
    80001dda:	c901                	beqz	a0,80001dea <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ddc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001de0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001de2:	14479073          	csrw	sip,a5
    return 2;
    80001de6:	4509                	li	a0,2
    80001de8:	b761                	j	80001d70 <devintr+0x1e>
      clockintr();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	f22080e7          	jalr	-222(ra) # 80001d0c <clockintr>
    80001df2:	b7ed                	j	80001ddc <devintr+0x8a>

0000000080001df4 <usertrap>:
{
    80001df4:	1101                	addi	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	e04a                	sd	s2,0(sp)
    80001dfe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e00:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e04:	1007f793          	andi	a5,a5,256
    80001e08:	e3b1                	bnez	a5,80001e4c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e0a:	00003797          	auipc	a5,0x3
    80001e0e:	42678793          	addi	a5,a5,1062 # 80005230 <kernelvec>
    80001e12:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	128080e7          	jalr	296(ra) # 80000f3e <myproc>
    80001e1e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e20:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	14102773          	csrr	a4,sepc
    80001e26:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e28:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e2c:	47a1                	li	a5,8
    80001e2e:	02f70763          	beq	a4,a5,80001e5c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	f20080e7          	jalr	-224(ra) # 80001d52 <devintr>
    80001e3a:	892a                	mv	s2,a0
    80001e3c:	c151                	beqz	a0,80001ec0 <usertrap+0xcc>
  if(killed(p))
    80001e3e:	8526                	mv	a0,s1
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	ad0080e7          	jalr	-1328(ra) # 80001910 <killed>
    80001e48:	c929                	beqz	a0,80001e9a <usertrap+0xa6>
    80001e4a:	a099                	j	80001e90 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	48450513          	addi	a0,a0,1156 # 800082d0 <states.0+0x58>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	fa8080e7          	jalr	-88(ra) # 80005dfc <panic>
    if(killed(p))
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	ab4080e7          	jalr	-1356(ra) # 80001910 <killed>
    80001e64:	e921                	bnez	a0,80001eb4 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e66:	70b8                	ld	a4,96(s1)
    80001e68:	6f1c                	ld	a5,24(a4)
    80001e6a:	0791                	addi	a5,a5,4
    80001e6c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e76:	10079073          	csrw	sstatus,a5
    syscall();
    80001e7a:	00000097          	auipc	ra,0x0
    80001e7e:	2d4080e7          	jalr	724(ra) # 8000214e <syscall>
  if(killed(p))
    80001e82:	8526                	mv	a0,s1
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	a8c080e7          	jalr	-1396(ra) # 80001910 <killed>
    80001e8c:	c911                	beqz	a0,80001ea0 <usertrap+0xac>
    80001e8e:	4901                	li	s2,0
    exit(-1);
    80001e90:	557d                	li	a0,-1
    80001e92:	00000097          	auipc	ra,0x0
    80001e96:	90a080e7          	jalr	-1782(ra) # 8000179c <exit>
  if(which_dev == 2)
    80001e9a:	4789                	li	a5,2
    80001e9c:	04f90f63          	beq	s2,a5,80001efa <usertrap+0x106>
  usertrapret();
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	dd6080e7          	jalr	-554(ra) # 80001c76 <usertrapret>
}
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	64a2                	ld	s1,8(sp)
    80001eae:	6902                	ld	s2,0(sp)
    80001eb0:	6105                	addi	sp,sp,32
    80001eb2:	8082                	ret
      exit(-1);
    80001eb4:	557d                	li	a0,-1
    80001eb6:	00000097          	auipc	ra,0x0
    80001eba:	8e6080e7          	jalr	-1818(ra) # 8000179c <exit>
    80001ebe:	b765                	j	80001e66 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ec0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ec4:	5890                	lw	a2,48(s1)
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	42a50513          	addi	a0,a0,1066 # 800082f0 <states.0+0x78>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	f78080e7          	jalr	-136(ra) # 80005e46 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eda:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	44250513          	addi	a0,a0,1090 # 80008320 <states.0+0xa8>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	f60080e7          	jalr	-160(ra) # 80005e46 <printf>
    setkilled(p);
    80001eee:	8526                	mv	a0,s1
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	9f4080e7          	jalr	-1548(ra) # 800018e4 <setkilled>
    80001ef8:	b769                	j	80001e82 <usertrap+0x8e>
    yield();
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	732080e7          	jalr	1842(ra) # 8000162c <yield>
    80001f02:	bf79                	j	80001ea0 <usertrap+0xac>

0000000080001f04 <kerneltrap>:
{
    80001f04:	7179                	addi	sp,sp,-48
    80001f06:	f406                	sd	ra,40(sp)
    80001f08:	f022                	sd	s0,32(sp)
    80001f0a:	ec26                	sd	s1,24(sp)
    80001f0c:	e84a                	sd	s2,16(sp)
    80001f0e:	e44e                	sd	s3,8(sp)
    80001f10:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f12:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f16:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f1a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f1e:	1004f793          	andi	a5,s1,256
    80001f22:	cb85                	beqz	a5,80001f52 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f24:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f28:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f2a:	ef85                	bnez	a5,80001f62 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f2c:	00000097          	auipc	ra,0x0
    80001f30:	e26080e7          	jalr	-474(ra) # 80001d52 <devintr>
    80001f34:	cd1d                	beqz	a0,80001f72 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f36:	4789                	li	a5,2
    80001f38:	06f50a63          	beq	a0,a5,80001fac <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f3c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f40:	10049073          	csrw	sstatus,s1
}
    80001f44:	70a2                	ld	ra,40(sp)
    80001f46:	7402                	ld	s0,32(sp)
    80001f48:	64e2                	ld	s1,24(sp)
    80001f4a:	6942                	ld	s2,16(sp)
    80001f4c:	69a2                	ld	s3,8(sp)
    80001f4e:	6145                	addi	sp,sp,48
    80001f50:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f52:	00006517          	auipc	a0,0x6
    80001f56:	3ee50513          	addi	a0,a0,1006 # 80008340 <states.0+0xc8>
    80001f5a:	00004097          	auipc	ra,0x4
    80001f5e:	ea2080e7          	jalr	-350(ra) # 80005dfc <panic>
    panic("kerneltrap: interrupts enabled");
    80001f62:	00006517          	auipc	a0,0x6
    80001f66:	40650513          	addi	a0,a0,1030 # 80008368 <states.0+0xf0>
    80001f6a:	00004097          	auipc	ra,0x4
    80001f6e:	e92080e7          	jalr	-366(ra) # 80005dfc <panic>
    printf("scause %p\n", scause);
    80001f72:	85ce                	mv	a1,s3
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	41450513          	addi	a0,a0,1044 # 80008388 <states.0+0x110>
    80001f7c:	00004097          	auipc	ra,0x4
    80001f80:	eca080e7          	jalr	-310(ra) # 80005e46 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f88:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f8c:	00006517          	auipc	a0,0x6
    80001f90:	40c50513          	addi	a0,a0,1036 # 80008398 <states.0+0x120>
    80001f94:	00004097          	auipc	ra,0x4
    80001f98:	eb2080e7          	jalr	-334(ra) # 80005e46 <printf>
    panic("kerneltrap");
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	41450513          	addi	a0,a0,1044 # 800083b0 <states.0+0x138>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	e58080e7          	jalr	-424(ra) # 80005dfc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	f92080e7          	jalr	-110(ra) # 80000f3e <myproc>
    80001fb4:	d541                	beqz	a0,80001f3c <kerneltrap+0x38>
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	f88080e7          	jalr	-120(ra) # 80000f3e <myproc>
    80001fbe:	4d18                	lw	a4,24(a0)
    80001fc0:	4791                	li	a5,4
    80001fc2:	f6f71de3          	bne	a4,a5,80001f3c <kerneltrap+0x38>
    yield();
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	666080e7          	jalr	1638(ra) # 8000162c <yield>
    80001fce:	b7bd                	j	80001f3c <kerneltrap+0x38>

0000000080001fd0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	e426                	sd	s1,8(sp)
    80001fd8:	1000                	addi	s0,sp,32
    80001fda:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	f62080e7          	jalr	-158(ra) # 80000f3e <myproc>
  switch (n) {
    80001fe4:	4795                	li	a5,5
    80001fe6:	0497e163          	bltu	a5,s1,80002028 <argraw+0x58>
    80001fea:	048a                	slli	s1,s1,0x2
    80001fec:	00006717          	auipc	a4,0x6
    80001ff0:	3fc70713          	addi	a4,a4,1020 # 800083e8 <states.0+0x170>
    80001ff4:	94ba                	add	s1,s1,a4
    80001ff6:	409c                	lw	a5,0(s1)
    80001ff8:	97ba                	add	a5,a5,a4
    80001ffa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ffc:	713c                	ld	a5,96(a0)
    80001ffe:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret
    return p->trapframe->a1;
    8000200a:	713c                	ld	a5,96(a0)
    8000200c:	7fa8                	ld	a0,120(a5)
    8000200e:	bfcd                	j	80002000 <argraw+0x30>
    return p->trapframe->a2;
    80002010:	713c                	ld	a5,96(a0)
    80002012:	63c8                	ld	a0,128(a5)
    80002014:	b7f5                	j	80002000 <argraw+0x30>
    return p->trapframe->a3;
    80002016:	713c                	ld	a5,96(a0)
    80002018:	67c8                	ld	a0,136(a5)
    8000201a:	b7dd                	j	80002000 <argraw+0x30>
    return p->trapframe->a4;
    8000201c:	713c                	ld	a5,96(a0)
    8000201e:	6bc8                	ld	a0,144(a5)
    80002020:	b7c5                	j	80002000 <argraw+0x30>
    return p->trapframe->a5;
    80002022:	713c                	ld	a5,96(a0)
    80002024:	6fc8                	ld	a0,152(a5)
    80002026:	bfe9                	j	80002000 <argraw+0x30>
  panic("argraw");
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	39850513          	addi	a0,a0,920 # 800083c0 <states.0+0x148>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	dcc080e7          	jalr	-564(ra) # 80005dfc <panic>

0000000080002038 <fetchaddr>:
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	e04a                	sd	s2,0(sp)
    80002042:	1000                	addi	s0,sp,32
    80002044:	84aa                	mv	s1,a0
    80002046:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	ef6080e7          	jalr	-266(ra) # 80000f3e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002050:	653c                	ld	a5,72(a0)
    80002052:	02f4f863          	bgeu	s1,a5,80002082 <fetchaddr+0x4a>
    80002056:	00848713          	addi	a4,s1,8
    8000205a:	02e7e663          	bltu	a5,a4,80002086 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000205e:	46a1                	li	a3,8
    80002060:	8626                	mv	a2,s1
    80002062:	85ca                	mv	a1,s2
    80002064:	6928                	ld	a0,80(a0)
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	b3a080e7          	jalr	-1222(ra) # 80000ba0 <copyin>
    8000206e:	00a03533          	snez	a0,a0
    80002072:	40a00533          	neg	a0,a0
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6902                	ld	s2,0(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret
    return -1;
    80002082:	557d                	li	a0,-1
    80002084:	bfcd                	j	80002076 <fetchaddr+0x3e>
    80002086:	557d                	li	a0,-1
    80002088:	b7fd                	j	80002076 <fetchaddr+0x3e>

000000008000208a <fetchstr>:
{
    8000208a:	7179                	addi	sp,sp,-48
    8000208c:	f406                	sd	ra,40(sp)
    8000208e:	f022                	sd	s0,32(sp)
    80002090:	ec26                	sd	s1,24(sp)
    80002092:	e84a                	sd	s2,16(sp)
    80002094:	e44e                	sd	s3,8(sp)
    80002096:	1800                	addi	s0,sp,48
    80002098:	892a                	mv	s2,a0
    8000209a:	84ae                	mv	s1,a1
    8000209c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	ea0080e7          	jalr	-352(ra) # 80000f3e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020a6:	86ce                	mv	a3,s3
    800020a8:	864a                	mv	a2,s2
    800020aa:	85a6                	mv	a1,s1
    800020ac:	6928                	ld	a0,80(a0)
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	b80080e7          	jalr	-1152(ra) # 80000c2e <copyinstr>
    800020b6:	00054e63          	bltz	a0,800020d2 <fetchstr+0x48>
  return strlen(buf);
    800020ba:	8526                	mv	a0,s1
    800020bc:	ffffe097          	auipc	ra,0xffffe
    800020c0:	23a080e7          	jalr	570(ra) # 800002f6 <strlen>
}
    800020c4:	70a2                	ld	ra,40(sp)
    800020c6:	7402                	ld	s0,32(sp)
    800020c8:	64e2                	ld	s1,24(sp)
    800020ca:	6942                	ld	s2,16(sp)
    800020cc:	69a2                	ld	s3,8(sp)
    800020ce:	6145                	addi	sp,sp,48
    800020d0:	8082                	ret
    return -1;
    800020d2:	557d                	li	a0,-1
    800020d4:	bfc5                	j	800020c4 <fetchstr+0x3a>

00000000800020d6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	e426                	sd	s1,8(sp)
    800020de:	1000                	addi	s0,sp,32
    800020e0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	eee080e7          	jalr	-274(ra) # 80001fd0 <argraw>
    800020ea:	c088                	sw	a0,0(s1)
}
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002102:	00000097          	auipc	ra,0x0
    80002106:	ece080e7          	jalr	-306(ra) # 80001fd0 <argraw>
    8000210a:	e088                	sd	a0,0(s1)
}
    8000210c:	60e2                	ld	ra,24(sp)
    8000210e:	6442                	ld	s0,16(sp)
    80002110:	64a2                	ld	s1,8(sp)
    80002112:	6105                	addi	sp,sp,32
    80002114:	8082                	ret

0000000080002116 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002116:	7179                	addi	sp,sp,-48
    80002118:	f406                	sd	ra,40(sp)
    8000211a:	f022                	sd	s0,32(sp)
    8000211c:	ec26                	sd	s1,24(sp)
    8000211e:	e84a                	sd	s2,16(sp)
    80002120:	1800                	addi	s0,sp,48
    80002122:	84ae                	mv	s1,a1
    80002124:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002126:	fd840593          	addi	a1,s0,-40
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	fcc080e7          	jalr	-52(ra) # 800020f6 <argaddr>
  return fetchstr(addr, buf, max);
    80002132:	864a                	mv	a2,s2
    80002134:	85a6                	mv	a1,s1
    80002136:	fd843503          	ld	a0,-40(s0)
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	f50080e7          	jalr	-176(ra) # 8000208a <fetchstr>
}
    80002142:	70a2                	ld	ra,40(sp)
    80002144:	7402                	ld	s0,32(sp)
    80002146:	64e2                	ld	s1,24(sp)
    80002148:	6942                	ld	s2,16(sp)
    8000214a:	6145                	addi	sp,sp,48
    8000214c:	8082                	ret

000000008000214e <syscall>:



void
syscall(void)
{
    8000214e:	1101                	addi	sp,sp,-32
    80002150:	ec06                	sd	ra,24(sp)
    80002152:	e822                	sd	s0,16(sp)
    80002154:	e426                	sd	s1,8(sp)
    80002156:	e04a                	sd	s2,0(sp)
    80002158:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	de4080e7          	jalr	-540(ra) # 80000f3e <myproc>
    80002162:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002164:	06053903          	ld	s2,96(a0)
    80002168:	0a893783          	ld	a5,168(s2)
    8000216c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002170:	37fd                	addiw	a5,a5,-1
    80002172:	4775                	li	a4,29
    80002174:	00f76f63          	bltu	a4,a5,80002192 <syscall+0x44>
    80002178:	00369713          	slli	a4,a3,0x3
    8000217c:	00006797          	auipc	a5,0x6
    80002180:	28478793          	addi	a5,a5,644 # 80008400 <syscalls>
    80002184:	97ba                	add	a5,a5,a4
    80002186:	639c                	ld	a5,0(a5)
    80002188:	c789                	beqz	a5,80002192 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000218a:	9782                	jalr	a5
    8000218c:	06a93823          	sd	a0,112(s2)
    80002190:	a839                	j	800021ae <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002192:	16048613          	addi	a2,s1,352
    80002196:	588c                	lw	a1,48(s1)
    80002198:	00006517          	auipc	a0,0x6
    8000219c:	23050513          	addi	a0,a0,560 # 800083c8 <states.0+0x150>
    800021a0:	00004097          	auipc	ra,0x4
    800021a4:	ca6080e7          	jalr	-858(ra) # 80005e46 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021a8:	70bc                	ld	a5,96(s1)
    800021aa:	577d                	li	a4,-1
    800021ac:	fbb8                	sd	a4,112(a5)
  }
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	64a2                	ld	s1,8(sp)
    800021b4:	6902                	ld	s2,0(sp)
    800021b6:	6105                	addi	sp,sp,32
    800021b8:	8082                	ret

00000000800021ba <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021c2:	fec40593          	addi	a1,s0,-20
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	f0e080e7          	jalr	-242(ra) # 800020d6 <argint>
  exit(n);
    800021d0:	fec42503          	lw	a0,-20(s0)
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	5c8080e7          	jalr	1480(ra) # 8000179c <exit>
  return 0;  // not reached
}
    800021dc:	4501                	li	a0,0
    800021de:	60e2                	ld	ra,24(sp)
    800021e0:	6442                	ld	s0,16(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret

00000000800021e6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021e6:	1141                	addi	sp,sp,-16
    800021e8:	e406                	sd	ra,8(sp)
    800021ea:	e022                	sd	s0,0(sp)
    800021ec:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	d50080e7          	jalr	-688(ra) # 80000f3e <myproc>
}
    800021f6:	5908                	lw	a0,48(a0)
    800021f8:	60a2                	ld	ra,8(sp)
    800021fa:	6402                	ld	s0,0(sp)
    800021fc:	0141                	addi	sp,sp,16
    800021fe:	8082                	ret

0000000080002200 <sys_fork>:

uint64
sys_fork(void)
{
    80002200:	1141                	addi	sp,sp,-16
    80002202:	e406                	sd	ra,8(sp)
    80002204:	e022                	sd	s0,0(sp)
    80002206:	0800                	addi	s0,sp,16
  return fork();
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	16e080e7          	jalr	366(ra) # 80001376 <fork>
}
    80002210:	60a2                	ld	ra,8(sp)
    80002212:	6402                	ld	s0,0(sp)
    80002214:	0141                	addi	sp,sp,16
    80002216:	8082                	ret

0000000080002218 <sys_wait>:

uint64
sys_wait(void)
{
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002220:	fe840593          	addi	a1,s0,-24
    80002224:	4501                	li	a0,0
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	ed0080e7          	jalr	-304(ra) # 800020f6 <argaddr>
  return wait(p);
    8000222e:	fe843503          	ld	a0,-24(s0)
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	710080e7          	jalr	1808(ra) # 80001942 <wait>
}
    8000223a:	60e2                	ld	ra,24(sp)
    8000223c:	6442                	ld	s0,16(sp)
    8000223e:	6105                	addi	sp,sp,32
    80002240:	8082                	ret

0000000080002242 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002242:	7179                	addi	sp,sp,-48
    80002244:	f406                	sd	ra,40(sp)
    80002246:	f022                	sd	s0,32(sp)
    80002248:	ec26                	sd	s1,24(sp)
    8000224a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000224c:	fdc40593          	addi	a1,s0,-36
    80002250:	4501                	li	a0,0
    80002252:	00000097          	auipc	ra,0x0
    80002256:	e84080e7          	jalr	-380(ra) # 800020d6 <argint>
  addr = myproc()->sz;
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	ce4080e7          	jalr	-796(ra) # 80000f3e <myproc>
    80002262:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002264:	fdc42503          	lw	a0,-36(s0)
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	0b2080e7          	jalr	178(ra) # 8000131a <growproc>
    80002270:	00054863          	bltz	a0,80002280 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002274:	8526                	mv	a0,s1
    80002276:	70a2                	ld	ra,40(sp)
    80002278:	7402                	ld	s0,32(sp)
    8000227a:	64e2                	ld	s1,24(sp)
    8000227c:	6145                	addi	sp,sp,48
    8000227e:	8082                	ret
    return -1;
    80002280:	54fd                	li	s1,-1
    80002282:	bfcd                	j	80002274 <sys_sbrk+0x32>

0000000080002284 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002284:	7139                	addi	sp,sp,-64
    80002286:	fc06                	sd	ra,56(sp)
    80002288:	f822                	sd	s0,48(sp)
    8000228a:	f426                	sd	s1,40(sp)
    8000228c:	f04a                	sd	s2,32(sp)
    8000228e:	ec4e                	sd	s3,24(sp)
    80002290:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80002292:	fcc40593          	addi	a1,s0,-52
    80002296:	4501                	li	a0,0
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	e3e080e7          	jalr	-450(ra) # 800020d6 <argint>
  acquire(&tickslock);
    800022a0:	0000c517          	auipc	a0,0xc
    800022a4:	74050513          	addi	a0,a0,1856 # 8000e9e0 <tickslock>
    800022a8:	00004097          	auipc	ra,0x4
    800022ac:	08c080e7          	jalr	140(ra) # 80006334 <acquire>
  ticks0 = ticks;
    800022b0:	00006917          	auipc	s2,0x6
    800022b4:	6c092903          	lw	s2,1728(s2) # 80008970 <ticks>
  while(ticks - ticks0 < n){
    800022b8:	fcc42783          	lw	a5,-52(s0)
    800022bc:	cf9d                	beqz	a5,800022fa <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022be:	0000c997          	auipc	s3,0xc
    800022c2:	72298993          	addi	s3,s3,1826 # 8000e9e0 <tickslock>
    800022c6:	00006497          	auipc	s1,0x6
    800022ca:	6aa48493          	addi	s1,s1,1706 # 80008970 <ticks>
    if(killed(myproc())){
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	c70080e7          	jalr	-912(ra) # 80000f3e <myproc>
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	63a080e7          	jalr	1594(ra) # 80001910 <killed>
    800022de:	ed15                	bnez	a0,8000231a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800022e0:	85ce                	mv	a1,s3
    800022e2:	8526                	mv	a0,s1
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	384080e7          	jalr	900(ra) # 80001668 <sleep>
  while(ticks - ticks0 < n){
    800022ec:	409c                	lw	a5,0(s1)
    800022ee:	412787bb          	subw	a5,a5,s2
    800022f2:	fcc42703          	lw	a4,-52(s0)
    800022f6:	fce7ece3          	bltu	a5,a4,800022ce <sys_sleep+0x4a>
  }
  release(&tickslock);
    800022fa:	0000c517          	auipc	a0,0xc
    800022fe:	6e650513          	addi	a0,a0,1766 # 8000e9e0 <tickslock>
    80002302:	00004097          	auipc	ra,0x4
    80002306:	0e6080e7          	jalr	230(ra) # 800063e8 <release>
  return 0;
    8000230a:	4501                	li	a0,0
}
    8000230c:	70e2                	ld	ra,56(sp)
    8000230e:	7442                	ld	s0,48(sp)
    80002310:	74a2                	ld	s1,40(sp)
    80002312:	7902                	ld	s2,32(sp)
    80002314:	69e2                	ld	s3,24(sp)
    80002316:	6121                	addi	sp,sp,64
    80002318:	8082                	ret
      release(&tickslock);
    8000231a:	0000c517          	auipc	a0,0xc
    8000231e:	6c650513          	addi	a0,a0,1734 # 8000e9e0 <tickslock>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	0c6080e7          	jalr	198(ra) # 800063e8 <release>
      return -1;
    8000232a:	557d                	li	a0,-1
    8000232c:	b7c5                	j	8000230c <sys_sleep+0x88>

000000008000232e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000232e:	715d                	addi	sp,sp,-80
    80002330:	e486                	sd	ra,72(sp)
    80002332:	e0a2                	sd	s0,64(sp)
    80002334:	fc26                	sd	s1,56(sp)
    80002336:	f84a                	sd	s2,48(sp)
    80002338:	f44e                	sd	s3,40(sp)
    8000233a:	f052                	sd	s4,32(sp)
    8000233c:	0880                	addi	s0,sp,80
  uint64 va;
  int pagenum;
  uint64 abitsaddr;
  argaddr(0, &va);
    8000233e:	fc840593          	addi	a1,s0,-56
    80002342:	4501                	li	a0,0
    80002344:	00000097          	auipc	ra,0x0
    80002348:	db2080e7          	jalr	-590(ra) # 800020f6 <argaddr>
  argint(1, &pagenum);
    8000234c:	fc440593          	addi	a1,s0,-60
    80002350:	4505                	li	a0,1
    80002352:	00000097          	auipc	ra,0x0
    80002356:	d84080e7          	jalr	-636(ra) # 800020d6 <argint>
  argaddr(2, &abitsaddr);
    8000235a:	fb840593          	addi	a1,s0,-72
    8000235e:	4509                	li	a0,2
    80002360:	00000097          	auipc	ra,0x0
    80002364:	d96080e7          	jalr	-618(ra) # 800020f6 <argaddr>

  uint64 maskbits = 0;
    80002368:	fa043823          	sd	zero,-80(s0)
  struct proc *proc = myproc();
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	bd2080e7          	jalr	-1070(ra) # 80000f3e <myproc>
    80002374:	892a                	mv	s2,a0
  for (int i = 0; i < pagenum; i++) {
    80002376:	fc442783          	lw	a5,-60(s0)
    8000237a:	06f05463          	blez	a5,800023e2 <sys_pgaccess+0xb4>
    8000237e:	4481                	li	s1,0
    pte_t *pte = walk(proc->pagetable, va+i*PGSIZE, 0);
    if (pte == 0)
      panic("page not exist.");
    if (PTE_FLAGS(*pte) & PTE_A) {
      maskbits = maskbits | (1L << i);
    80002380:	4985                	li	s3,1
    80002382:	a025                	j	800023aa <sys_pgaccess+0x7c>
      panic("page not exist.");
    80002384:	00006517          	auipc	a0,0x6
    80002388:	17450513          	addi	a0,a0,372 # 800084f8 <syscalls+0xf8>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	a70080e7          	jalr	-1424(ra) # 80005dfc <panic>
    }
    // clear PTE_A, set PTE_A bits zero
    *pte = ((*pte&PTE_A) ^ *pte) ^ 0 ;
    80002394:	611c                	ld	a5,0(a0)
    80002396:	fbf7f793          	andi	a5,a5,-65
    8000239a:	e11c                	sd	a5,0(a0)
  for (int i = 0; i < pagenum; i++) {
    8000239c:	0485                	addi	s1,s1,1
    8000239e:	fc442703          	lw	a4,-60(s0)
    800023a2:	0004879b          	sext.w	a5,s1
    800023a6:	02e7de63          	bge	a5,a4,800023e2 <sys_pgaccess+0xb4>
    800023aa:	00048a1b          	sext.w	s4,s1
    pte_t *pte = walk(proc->pagetable, va+i*PGSIZE, 0);
    800023ae:	00c49593          	slli	a1,s1,0xc
    800023b2:	4601                	li	a2,0
    800023b4:	fc843783          	ld	a5,-56(s0)
    800023b8:	95be                	add	a1,a1,a5
    800023ba:	05093503          	ld	a0,80(s2)
    800023be:	ffffe097          	auipc	ra,0xffffe
    800023c2:	0a0080e7          	jalr	160(ra) # 8000045e <walk>
    if (pte == 0)
    800023c6:	dd5d                	beqz	a0,80002384 <sys_pgaccess+0x56>
    if (PTE_FLAGS(*pte) & PTE_A) {
    800023c8:	611c                	ld	a5,0(a0)
    800023ca:	0407f793          	andi	a5,a5,64
    800023ce:	d3f9                	beqz	a5,80002394 <sys_pgaccess+0x66>
      maskbits = maskbits | (1L << i);
    800023d0:	01499a33          	sll	s4,s3,s4
    800023d4:	fb043783          	ld	a5,-80(s0)
    800023d8:	0147e7b3          	or	a5,a5,s4
    800023dc:	faf43823          	sd	a5,-80(s0)
    800023e0:	bf55                	j	80002394 <sys_pgaccess+0x66>
  }
  if (copyout(proc->pagetable, abitsaddr, (char *)&maskbits, sizeof(maskbits)) < 0)
    800023e2:	46a1                	li	a3,8
    800023e4:	fb040613          	addi	a2,s0,-80
    800023e8:	fb843583          	ld	a1,-72(s0)
    800023ec:	05093503          	ld	a0,80(s2)
    800023f0:	ffffe097          	auipc	ra,0xffffe
    800023f4:	724080e7          	jalr	1828(ra) # 80000b14 <copyout>
    800023f8:	00054b63          	bltz	a0,8000240e <sys_pgaccess+0xe0>
    panic("sys_pgacess copyout error");

  return 0;
}
    800023fc:	4501                	li	a0,0
    800023fe:	60a6                	ld	ra,72(sp)
    80002400:	6406                	ld	s0,64(sp)
    80002402:	74e2                	ld	s1,56(sp)
    80002404:	7942                	ld	s2,48(sp)
    80002406:	79a2                	ld	s3,40(sp)
    80002408:	7a02                	ld	s4,32(sp)
    8000240a:	6161                	addi	sp,sp,80
    8000240c:	8082                	ret
    panic("sys_pgacess copyout error");
    8000240e:	00006517          	auipc	a0,0x6
    80002412:	0fa50513          	addi	a0,a0,250 # 80008508 <syscalls+0x108>
    80002416:	00004097          	auipc	ra,0x4
    8000241a:	9e6080e7          	jalr	-1562(ra) # 80005dfc <panic>

000000008000241e <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000241e:	1101                	addi	sp,sp,-32
    80002420:	ec06                	sd	ra,24(sp)
    80002422:	e822                	sd	s0,16(sp)
    80002424:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002426:	fec40593          	addi	a1,s0,-20
    8000242a:	4501                	li	a0,0
    8000242c:	00000097          	auipc	ra,0x0
    80002430:	caa080e7          	jalr	-854(ra) # 800020d6 <argint>
  return kill(pid);
    80002434:	fec42503          	lw	a0,-20(s0)
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	43a080e7          	jalr	1082(ra) # 80001872 <kill>
}
    80002440:	60e2                	ld	ra,24(sp)
    80002442:	6442                	ld	s0,16(sp)
    80002444:	6105                	addi	sp,sp,32
    80002446:	8082                	ret

0000000080002448 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002448:	1101                	addi	sp,sp,-32
    8000244a:	ec06                	sd	ra,24(sp)
    8000244c:	e822                	sd	s0,16(sp)
    8000244e:	e426                	sd	s1,8(sp)
    80002450:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002452:	0000c517          	auipc	a0,0xc
    80002456:	58e50513          	addi	a0,a0,1422 # 8000e9e0 <tickslock>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	eda080e7          	jalr	-294(ra) # 80006334 <acquire>
  xticks = ticks;
    80002462:	00006497          	auipc	s1,0x6
    80002466:	50e4a483          	lw	s1,1294(s1) # 80008970 <ticks>
  release(&tickslock);
    8000246a:	0000c517          	auipc	a0,0xc
    8000246e:	57650513          	addi	a0,a0,1398 # 8000e9e0 <tickslock>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	f76080e7          	jalr	-138(ra) # 800063e8 <release>
  return xticks;
}
    8000247a:	02049513          	slli	a0,s1,0x20
    8000247e:	9101                	srli	a0,a0,0x20
    80002480:	60e2                	ld	ra,24(sp)
    80002482:	6442                	ld	s0,16(sp)
    80002484:	64a2                	ld	s1,8(sp)
    80002486:	6105                	addi	sp,sp,32
    80002488:	8082                	ret

000000008000248a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000248a:	7179                	addi	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	e052                	sd	s4,0(sp)
    80002498:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000249a:	00006597          	auipc	a1,0x6
    8000249e:	08e58593          	addi	a1,a1,142 # 80008528 <syscalls+0x128>
    800024a2:	0000c517          	auipc	a0,0xc
    800024a6:	55650513          	addi	a0,a0,1366 # 8000e9f8 <bcache>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	dfa080e7          	jalr	-518(ra) # 800062a4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024b2:	00014797          	auipc	a5,0x14
    800024b6:	54678793          	addi	a5,a5,1350 # 800169f8 <bcache+0x8000>
    800024ba:	00014717          	auipc	a4,0x14
    800024be:	7a670713          	addi	a4,a4,1958 # 80016c60 <bcache+0x8268>
    800024c2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024c6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ca:	0000c497          	auipc	s1,0xc
    800024ce:	54648493          	addi	s1,s1,1350 # 8000ea10 <bcache+0x18>
    b->next = bcache.head.next;
    800024d2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024d4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024d6:	00006a17          	auipc	s4,0x6
    800024da:	05aa0a13          	addi	s4,s4,90 # 80008530 <syscalls+0x130>
    b->next = bcache.head.next;
    800024de:	2b893783          	ld	a5,696(s2)
    800024e2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024e4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024e8:	85d2                	mv	a1,s4
    800024ea:	01048513          	addi	a0,s1,16
    800024ee:	00001097          	auipc	ra,0x1
    800024f2:	4c8080e7          	jalr	1224(ra) # 800039b6 <initsleeplock>
    bcache.head.next->prev = b;
    800024f6:	2b893783          	ld	a5,696(s2)
    800024fa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024fc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002500:	45848493          	addi	s1,s1,1112
    80002504:	fd349de3          	bne	s1,s3,800024de <binit+0x54>
  }
}
    80002508:	70a2                	ld	ra,40(sp)
    8000250a:	7402                	ld	s0,32(sp)
    8000250c:	64e2                	ld	s1,24(sp)
    8000250e:	6942                	ld	s2,16(sp)
    80002510:	69a2                	ld	s3,8(sp)
    80002512:	6a02                	ld	s4,0(sp)
    80002514:	6145                	addi	sp,sp,48
    80002516:	8082                	ret

0000000080002518 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002518:	7179                	addi	sp,sp,-48
    8000251a:	f406                	sd	ra,40(sp)
    8000251c:	f022                	sd	s0,32(sp)
    8000251e:	ec26                	sd	s1,24(sp)
    80002520:	e84a                	sd	s2,16(sp)
    80002522:	e44e                	sd	s3,8(sp)
    80002524:	1800                	addi	s0,sp,48
    80002526:	892a                	mv	s2,a0
    80002528:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000252a:	0000c517          	auipc	a0,0xc
    8000252e:	4ce50513          	addi	a0,a0,1230 # 8000e9f8 <bcache>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	e02080e7          	jalr	-510(ra) # 80006334 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000253a:	00014497          	auipc	s1,0x14
    8000253e:	7764b483          	ld	s1,1910(s1) # 80016cb0 <bcache+0x82b8>
    80002542:	00014797          	auipc	a5,0x14
    80002546:	71e78793          	addi	a5,a5,1822 # 80016c60 <bcache+0x8268>
    8000254a:	02f48f63          	beq	s1,a5,80002588 <bread+0x70>
    8000254e:	873e                	mv	a4,a5
    80002550:	a021                	j	80002558 <bread+0x40>
    80002552:	68a4                	ld	s1,80(s1)
    80002554:	02e48a63          	beq	s1,a4,80002588 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002558:	449c                	lw	a5,8(s1)
    8000255a:	ff279ce3          	bne	a5,s2,80002552 <bread+0x3a>
    8000255e:	44dc                	lw	a5,12(s1)
    80002560:	ff3799e3          	bne	a5,s3,80002552 <bread+0x3a>
      b->refcnt++;
    80002564:	40bc                	lw	a5,64(s1)
    80002566:	2785                	addiw	a5,a5,1
    80002568:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000256a:	0000c517          	auipc	a0,0xc
    8000256e:	48e50513          	addi	a0,a0,1166 # 8000e9f8 <bcache>
    80002572:	00004097          	auipc	ra,0x4
    80002576:	e76080e7          	jalr	-394(ra) # 800063e8 <release>
      acquiresleep(&b->lock);
    8000257a:	01048513          	addi	a0,s1,16
    8000257e:	00001097          	auipc	ra,0x1
    80002582:	472080e7          	jalr	1138(ra) # 800039f0 <acquiresleep>
      return b;
    80002586:	a8b9                	j	800025e4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002588:	00014497          	auipc	s1,0x14
    8000258c:	7204b483          	ld	s1,1824(s1) # 80016ca8 <bcache+0x82b0>
    80002590:	00014797          	auipc	a5,0x14
    80002594:	6d078793          	addi	a5,a5,1744 # 80016c60 <bcache+0x8268>
    80002598:	00f48863          	beq	s1,a5,800025a8 <bread+0x90>
    8000259c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000259e:	40bc                	lw	a5,64(s1)
    800025a0:	cf81                	beqz	a5,800025b8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025a2:	64a4                	ld	s1,72(s1)
    800025a4:	fee49de3          	bne	s1,a4,8000259e <bread+0x86>
  panic("bget: no buffers");
    800025a8:	00006517          	auipc	a0,0x6
    800025ac:	f9050513          	addi	a0,a0,-112 # 80008538 <syscalls+0x138>
    800025b0:	00004097          	auipc	ra,0x4
    800025b4:	84c080e7          	jalr	-1972(ra) # 80005dfc <panic>
      b->dev = dev;
    800025b8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025bc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025c0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025c4:	4785                	li	a5,1
    800025c6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c8:	0000c517          	auipc	a0,0xc
    800025cc:	43050513          	addi	a0,a0,1072 # 8000e9f8 <bcache>
    800025d0:	00004097          	auipc	ra,0x4
    800025d4:	e18080e7          	jalr	-488(ra) # 800063e8 <release>
      acquiresleep(&b->lock);
    800025d8:	01048513          	addi	a0,s1,16
    800025dc:	00001097          	auipc	ra,0x1
    800025e0:	414080e7          	jalr	1044(ra) # 800039f0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025e4:	409c                	lw	a5,0(s1)
    800025e6:	cb89                	beqz	a5,800025f8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025e8:	8526                	mv	a0,s1
    800025ea:	70a2                	ld	ra,40(sp)
    800025ec:	7402                	ld	s0,32(sp)
    800025ee:	64e2                	ld	s1,24(sp)
    800025f0:	6942                	ld	s2,16(sp)
    800025f2:	69a2                	ld	s3,8(sp)
    800025f4:	6145                	addi	sp,sp,48
    800025f6:	8082                	ret
    virtio_disk_rw(b, 0);
    800025f8:	4581                	li	a1,0
    800025fa:	8526                	mv	a0,s1
    800025fc:	00003097          	auipc	ra,0x3
    80002600:	ff6080e7          	jalr	-10(ra) # 800055f2 <virtio_disk_rw>
    b->valid = 1;
    80002604:	4785                	li	a5,1
    80002606:	c09c                	sw	a5,0(s1)
  return b;
    80002608:	b7c5                	j	800025e8 <bread+0xd0>

000000008000260a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000260a:	1101                	addi	sp,sp,-32
    8000260c:	ec06                	sd	ra,24(sp)
    8000260e:	e822                	sd	s0,16(sp)
    80002610:	e426                	sd	s1,8(sp)
    80002612:	1000                	addi	s0,sp,32
    80002614:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002616:	0541                	addi	a0,a0,16
    80002618:	00001097          	auipc	ra,0x1
    8000261c:	472080e7          	jalr	1138(ra) # 80003a8a <holdingsleep>
    80002620:	cd01                	beqz	a0,80002638 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002622:	4585                	li	a1,1
    80002624:	8526                	mv	a0,s1
    80002626:	00003097          	auipc	ra,0x3
    8000262a:	fcc080e7          	jalr	-52(ra) # 800055f2 <virtio_disk_rw>
}
    8000262e:	60e2                	ld	ra,24(sp)
    80002630:	6442                	ld	s0,16(sp)
    80002632:	64a2                	ld	s1,8(sp)
    80002634:	6105                	addi	sp,sp,32
    80002636:	8082                	ret
    panic("bwrite");
    80002638:	00006517          	auipc	a0,0x6
    8000263c:	f1850513          	addi	a0,a0,-232 # 80008550 <syscalls+0x150>
    80002640:	00003097          	auipc	ra,0x3
    80002644:	7bc080e7          	jalr	1980(ra) # 80005dfc <panic>

0000000080002648 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002648:	1101                	addi	sp,sp,-32
    8000264a:	ec06                	sd	ra,24(sp)
    8000264c:	e822                	sd	s0,16(sp)
    8000264e:	e426                	sd	s1,8(sp)
    80002650:	e04a                	sd	s2,0(sp)
    80002652:	1000                	addi	s0,sp,32
    80002654:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002656:	01050913          	addi	s2,a0,16
    8000265a:	854a                	mv	a0,s2
    8000265c:	00001097          	auipc	ra,0x1
    80002660:	42e080e7          	jalr	1070(ra) # 80003a8a <holdingsleep>
    80002664:	c92d                	beqz	a0,800026d6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002666:	854a                	mv	a0,s2
    80002668:	00001097          	auipc	ra,0x1
    8000266c:	3de080e7          	jalr	990(ra) # 80003a46 <releasesleep>

  acquire(&bcache.lock);
    80002670:	0000c517          	auipc	a0,0xc
    80002674:	38850513          	addi	a0,a0,904 # 8000e9f8 <bcache>
    80002678:	00004097          	auipc	ra,0x4
    8000267c:	cbc080e7          	jalr	-836(ra) # 80006334 <acquire>
  b->refcnt--;
    80002680:	40bc                	lw	a5,64(s1)
    80002682:	37fd                	addiw	a5,a5,-1
    80002684:	0007871b          	sext.w	a4,a5
    80002688:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000268a:	eb05                	bnez	a4,800026ba <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000268c:	68bc                	ld	a5,80(s1)
    8000268e:	64b8                	ld	a4,72(s1)
    80002690:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002692:	64bc                	ld	a5,72(s1)
    80002694:	68b8                	ld	a4,80(s1)
    80002696:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002698:	00014797          	auipc	a5,0x14
    8000269c:	36078793          	addi	a5,a5,864 # 800169f8 <bcache+0x8000>
    800026a0:	2b87b703          	ld	a4,696(a5)
    800026a4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026a6:	00014717          	auipc	a4,0x14
    800026aa:	5ba70713          	addi	a4,a4,1466 # 80016c60 <bcache+0x8268>
    800026ae:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026b0:	2b87b703          	ld	a4,696(a5)
    800026b4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026b6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ba:	0000c517          	auipc	a0,0xc
    800026be:	33e50513          	addi	a0,a0,830 # 8000e9f8 <bcache>
    800026c2:	00004097          	auipc	ra,0x4
    800026c6:	d26080e7          	jalr	-730(ra) # 800063e8 <release>
}
    800026ca:	60e2                	ld	ra,24(sp)
    800026cc:	6442                	ld	s0,16(sp)
    800026ce:	64a2                	ld	s1,8(sp)
    800026d0:	6902                	ld	s2,0(sp)
    800026d2:	6105                	addi	sp,sp,32
    800026d4:	8082                	ret
    panic("brelse");
    800026d6:	00006517          	auipc	a0,0x6
    800026da:	e8250513          	addi	a0,a0,-382 # 80008558 <syscalls+0x158>
    800026de:	00003097          	auipc	ra,0x3
    800026e2:	71e080e7          	jalr	1822(ra) # 80005dfc <panic>

00000000800026e6 <bpin>:

void
bpin(struct buf *b) {
    800026e6:	1101                	addi	sp,sp,-32
    800026e8:	ec06                	sd	ra,24(sp)
    800026ea:	e822                	sd	s0,16(sp)
    800026ec:	e426                	sd	s1,8(sp)
    800026ee:	1000                	addi	s0,sp,32
    800026f0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026f2:	0000c517          	auipc	a0,0xc
    800026f6:	30650513          	addi	a0,a0,774 # 8000e9f8 <bcache>
    800026fa:	00004097          	auipc	ra,0x4
    800026fe:	c3a080e7          	jalr	-966(ra) # 80006334 <acquire>
  b->refcnt++;
    80002702:	40bc                	lw	a5,64(s1)
    80002704:	2785                	addiw	a5,a5,1
    80002706:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002708:	0000c517          	auipc	a0,0xc
    8000270c:	2f050513          	addi	a0,a0,752 # 8000e9f8 <bcache>
    80002710:	00004097          	auipc	ra,0x4
    80002714:	cd8080e7          	jalr	-808(ra) # 800063e8 <release>
}
    80002718:	60e2                	ld	ra,24(sp)
    8000271a:	6442                	ld	s0,16(sp)
    8000271c:	64a2                	ld	s1,8(sp)
    8000271e:	6105                	addi	sp,sp,32
    80002720:	8082                	ret

0000000080002722 <bunpin>:

void
bunpin(struct buf *b) {
    80002722:	1101                	addi	sp,sp,-32
    80002724:	ec06                	sd	ra,24(sp)
    80002726:	e822                	sd	s0,16(sp)
    80002728:	e426                	sd	s1,8(sp)
    8000272a:	1000                	addi	s0,sp,32
    8000272c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000272e:	0000c517          	auipc	a0,0xc
    80002732:	2ca50513          	addi	a0,a0,714 # 8000e9f8 <bcache>
    80002736:	00004097          	auipc	ra,0x4
    8000273a:	bfe080e7          	jalr	-1026(ra) # 80006334 <acquire>
  b->refcnt--;
    8000273e:	40bc                	lw	a5,64(s1)
    80002740:	37fd                	addiw	a5,a5,-1
    80002742:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002744:	0000c517          	auipc	a0,0xc
    80002748:	2b450513          	addi	a0,a0,692 # 8000e9f8 <bcache>
    8000274c:	00004097          	auipc	ra,0x4
    80002750:	c9c080e7          	jalr	-868(ra) # 800063e8 <release>
}
    80002754:	60e2                	ld	ra,24(sp)
    80002756:	6442                	ld	s0,16(sp)
    80002758:	64a2                	ld	s1,8(sp)
    8000275a:	6105                	addi	sp,sp,32
    8000275c:	8082                	ret

000000008000275e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000275e:	1101                	addi	sp,sp,-32
    80002760:	ec06                	sd	ra,24(sp)
    80002762:	e822                	sd	s0,16(sp)
    80002764:	e426                	sd	s1,8(sp)
    80002766:	e04a                	sd	s2,0(sp)
    80002768:	1000                	addi	s0,sp,32
    8000276a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000276c:	00d5d59b          	srliw	a1,a1,0xd
    80002770:	00015797          	auipc	a5,0x15
    80002774:	9647a783          	lw	a5,-1692(a5) # 800170d4 <sb+0x1c>
    80002778:	9dbd                	addw	a1,a1,a5
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	d9e080e7          	jalr	-610(ra) # 80002518 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002782:	0074f713          	andi	a4,s1,7
    80002786:	4785                	li	a5,1
    80002788:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000278c:	14ce                	slli	s1,s1,0x33
    8000278e:	90d9                	srli	s1,s1,0x36
    80002790:	00950733          	add	a4,a0,s1
    80002794:	05874703          	lbu	a4,88(a4)
    80002798:	00e7f6b3          	and	a3,a5,a4
    8000279c:	c69d                	beqz	a3,800027ca <bfree+0x6c>
    8000279e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027a0:	94aa                	add	s1,s1,a0
    800027a2:	fff7c793          	not	a5,a5
    800027a6:	8f7d                	and	a4,a4,a5
    800027a8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027ac:	00001097          	auipc	ra,0x1
    800027b0:	126080e7          	jalr	294(ra) # 800038d2 <log_write>
  brelse(bp);
    800027b4:	854a                	mv	a0,s2
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	e92080e7          	jalr	-366(ra) # 80002648 <brelse>
}
    800027be:	60e2                	ld	ra,24(sp)
    800027c0:	6442                	ld	s0,16(sp)
    800027c2:	64a2                	ld	s1,8(sp)
    800027c4:	6902                	ld	s2,0(sp)
    800027c6:	6105                	addi	sp,sp,32
    800027c8:	8082                	ret
    panic("freeing free block");
    800027ca:	00006517          	auipc	a0,0x6
    800027ce:	d9650513          	addi	a0,a0,-618 # 80008560 <syscalls+0x160>
    800027d2:	00003097          	auipc	ra,0x3
    800027d6:	62a080e7          	jalr	1578(ra) # 80005dfc <panic>

00000000800027da <balloc>:
{
    800027da:	711d                	addi	sp,sp,-96
    800027dc:	ec86                	sd	ra,88(sp)
    800027de:	e8a2                	sd	s0,80(sp)
    800027e0:	e4a6                	sd	s1,72(sp)
    800027e2:	e0ca                	sd	s2,64(sp)
    800027e4:	fc4e                	sd	s3,56(sp)
    800027e6:	f852                	sd	s4,48(sp)
    800027e8:	f456                	sd	s5,40(sp)
    800027ea:	f05a                	sd	s6,32(sp)
    800027ec:	ec5e                	sd	s7,24(sp)
    800027ee:	e862                	sd	s8,16(sp)
    800027f0:	e466                	sd	s9,8(sp)
    800027f2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027f4:	00015797          	auipc	a5,0x15
    800027f8:	8c87a783          	lw	a5,-1848(a5) # 800170bc <sb+0x4>
    800027fc:	cff5                	beqz	a5,800028f8 <balloc+0x11e>
    800027fe:	8baa                	mv	s7,a0
    80002800:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002802:	00015b17          	auipc	s6,0x15
    80002806:	8b6b0b13          	addi	s6,s6,-1866 # 800170b8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000280c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002810:	6c89                	lui	s9,0x2
    80002812:	a061                	j	8000289a <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002814:	97ca                	add	a5,a5,s2
    80002816:	8e55                	or	a2,a2,a3
    80002818:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000281c:	854a                	mv	a0,s2
    8000281e:	00001097          	auipc	ra,0x1
    80002822:	0b4080e7          	jalr	180(ra) # 800038d2 <log_write>
        brelse(bp);
    80002826:	854a                	mv	a0,s2
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e20080e7          	jalr	-480(ra) # 80002648 <brelse>
  bp = bread(dev, bno);
    80002830:	85a6                	mv	a1,s1
    80002832:	855e                	mv	a0,s7
    80002834:	00000097          	auipc	ra,0x0
    80002838:	ce4080e7          	jalr	-796(ra) # 80002518 <bread>
    8000283c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000283e:	40000613          	li	a2,1024
    80002842:	4581                	li	a1,0
    80002844:	05850513          	addi	a0,a0,88
    80002848:	ffffe097          	auipc	ra,0xffffe
    8000284c:	932080e7          	jalr	-1742(ra) # 8000017a <memset>
  log_write(bp);
    80002850:	854a                	mv	a0,s2
    80002852:	00001097          	auipc	ra,0x1
    80002856:	080080e7          	jalr	128(ra) # 800038d2 <log_write>
  brelse(bp);
    8000285a:	854a                	mv	a0,s2
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	dec080e7          	jalr	-532(ra) # 80002648 <brelse>
}
    80002864:	8526                	mv	a0,s1
    80002866:	60e6                	ld	ra,88(sp)
    80002868:	6446                	ld	s0,80(sp)
    8000286a:	64a6                	ld	s1,72(sp)
    8000286c:	6906                	ld	s2,64(sp)
    8000286e:	79e2                	ld	s3,56(sp)
    80002870:	7a42                	ld	s4,48(sp)
    80002872:	7aa2                	ld	s5,40(sp)
    80002874:	7b02                	ld	s6,32(sp)
    80002876:	6be2                	ld	s7,24(sp)
    80002878:	6c42                	ld	s8,16(sp)
    8000287a:	6ca2                	ld	s9,8(sp)
    8000287c:	6125                	addi	sp,sp,96
    8000287e:	8082                	ret
    brelse(bp);
    80002880:	854a                	mv	a0,s2
    80002882:	00000097          	auipc	ra,0x0
    80002886:	dc6080e7          	jalr	-570(ra) # 80002648 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000288a:	015c87bb          	addw	a5,s9,s5
    8000288e:	00078a9b          	sext.w	s5,a5
    80002892:	004b2703          	lw	a4,4(s6)
    80002896:	06eaf163          	bgeu	s5,a4,800028f8 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000289a:	41fad79b          	sraiw	a5,s5,0x1f
    8000289e:	0137d79b          	srliw	a5,a5,0x13
    800028a2:	015787bb          	addw	a5,a5,s5
    800028a6:	40d7d79b          	sraiw	a5,a5,0xd
    800028aa:	01cb2583          	lw	a1,28(s6)
    800028ae:	9dbd                	addw	a1,a1,a5
    800028b0:	855e                	mv	a0,s7
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	c66080e7          	jalr	-922(ra) # 80002518 <bread>
    800028ba:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028bc:	004b2503          	lw	a0,4(s6)
    800028c0:	000a849b          	sext.w	s1,s5
    800028c4:	8762                	mv	a4,s8
    800028c6:	faa4fde3          	bgeu	s1,a0,80002880 <balloc+0xa6>
      m = 1 << (bi % 8);
    800028ca:	00777693          	andi	a3,a4,7
    800028ce:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028d2:	41f7579b          	sraiw	a5,a4,0x1f
    800028d6:	01d7d79b          	srliw	a5,a5,0x1d
    800028da:	9fb9                	addw	a5,a5,a4
    800028dc:	4037d79b          	sraiw	a5,a5,0x3
    800028e0:	00f90633          	add	a2,s2,a5
    800028e4:	05864603          	lbu	a2,88(a2)
    800028e8:	00c6f5b3          	and	a1,a3,a2
    800028ec:	d585                	beqz	a1,80002814 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ee:	2705                	addiw	a4,a4,1
    800028f0:	2485                	addiw	s1,s1,1
    800028f2:	fd471ae3          	bne	a4,s4,800028c6 <balloc+0xec>
    800028f6:	b769                	j	80002880 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800028f8:	00006517          	auipc	a0,0x6
    800028fc:	c8050513          	addi	a0,a0,-896 # 80008578 <syscalls+0x178>
    80002900:	00003097          	auipc	ra,0x3
    80002904:	546080e7          	jalr	1350(ra) # 80005e46 <printf>
  return 0;
    80002908:	4481                	li	s1,0
    8000290a:	bfa9                	j	80002864 <balloc+0x8a>

000000008000290c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000290c:	7179                	addi	sp,sp,-48
    8000290e:	f406                	sd	ra,40(sp)
    80002910:	f022                	sd	s0,32(sp)
    80002912:	ec26                	sd	s1,24(sp)
    80002914:	e84a                	sd	s2,16(sp)
    80002916:	e44e                	sd	s3,8(sp)
    80002918:	e052                	sd	s4,0(sp)
    8000291a:	1800                	addi	s0,sp,48
    8000291c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000291e:	47ad                	li	a5,11
    80002920:	02b7e863          	bltu	a5,a1,80002950 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002924:	02059793          	slli	a5,a1,0x20
    80002928:	01e7d593          	srli	a1,a5,0x1e
    8000292c:	00b504b3          	add	s1,a0,a1
    80002930:	0504a903          	lw	s2,80(s1)
    80002934:	06091e63          	bnez	s2,800029b0 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002938:	4108                	lw	a0,0(a0)
    8000293a:	00000097          	auipc	ra,0x0
    8000293e:	ea0080e7          	jalr	-352(ra) # 800027da <balloc>
    80002942:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002946:	06090563          	beqz	s2,800029b0 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000294a:	0524a823          	sw	s2,80(s1)
    8000294e:	a08d                	j	800029b0 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002950:	ff45849b          	addiw	s1,a1,-12
    80002954:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002958:	0ff00793          	li	a5,255
    8000295c:	08e7e563          	bltu	a5,a4,800029e6 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002960:	08052903          	lw	s2,128(a0)
    80002964:	00091d63          	bnez	s2,8000297e <bmap+0x72>
      addr = balloc(ip->dev);
    80002968:	4108                	lw	a0,0(a0)
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	e70080e7          	jalr	-400(ra) # 800027da <balloc>
    80002972:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002976:	02090d63          	beqz	s2,800029b0 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000297a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000297e:	85ca                	mv	a1,s2
    80002980:	0009a503          	lw	a0,0(s3)
    80002984:	00000097          	auipc	ra,0x0
    80002988:	b94080e7          	jalr	-1132(ra) # 80002518 <bread>
    8000298c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000298e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002992:	02049713          	slli	a4,s1,0x20
    80002996:	01e75593          	srli	a1,a4,0x1e
    8000299a:	00b784b3          	add	s1,a5,a1
    8000299e:	0004a903          	lw	s2,0(s1)
    800029a2:	02090063          	beqz	s2,800029c2 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029a6:	8552                	mv	a0,s4
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	ca0080e7          	jalr	-864(ra) # 80002648 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029b0:	854a                	mv	a0,s2
    800029b2:	70a2                	ld	ra,40(sp)
    800029b4:	7402                	ld	s0,32(sp)
    800029b6:	64e2                	ld	s1,24(sp)
    800029b8:	6942                	ld	s2,16(sp)
    800029ba:	69a2                	ld	s3,8(sp)
    800029bc:	6a02                	ld	s4,0(sp)
    800029be:	6145                	addi	sp,sp,48
    800029c0:	8082                	ret
      addr = balloc(ip->dev);
    800029c2:	0009a503          	lw	a0,0(s3)
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	e14080e7          	jalr	-492(ra) # 800027da <balloc>
    800029ce:	0005091b          	sext.w	s2,a0
      if(addr){
    800029d2:	fc090ae3          	beqz	s2,800029a6 <bmap+0x9a>
        a[bn] = addr;
    800029d6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800029da:	8552                	mv	a0,s4
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	ef6080e7          	jalr	-266(ra) # 800038d2 <log_write>
    800029e4:	b7c9                	j	800029a6 <bmap+0x9a>
  panic("bmap: out of range");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	baa50513          	addi	a0,a0,-1110 # 80008590 <syscalls+0x190>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	40e080e7          	jalr	1038(ra) # 80005dfc <panic>

00000000800029f6 <iget>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	e052                	sd	s4,0(sp)
    80002a04:	1800                	addi	s0,sp,48
    80002a06:	89aa                	mv	s3,a0
    80002a08:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a0a:	00014517          	auipc	a0,0x14
    80002a0e:	6ce50513          	addi	a0,a0,1742 # 800170d8 <itable>
    80002a12:	00004097          	auipc	ra,0x4
    80002a16:	922080e7          	jalr	-1758(ra) # 80006334 <acquire>
  empty = 0;
    80002a1a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1c:	00014497          	auipc	s1,0x14
    80002a20:	6d448493          	addi	s1,s1,1748 # 800170f0 <itable+0x18>
    80002a24:	00016697          	auipc	a3,0x16
    80002a28:	15c68693          	addi	a3,a3,348 # 80018b80 <log>
    80002a2c:	a039                	j	80002a3a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2e:	02090b63          	beqz	s2,80002a64 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a32:	08848493          	addi	s1,s1,136
    80002a36:	02d48a63          	beq	s1,a3,80002a6a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a3a:	449c                	lw	a5,8(s1)
    80002a3c:	fef059e3          	blez	a5,80002a2e <iget+0x38>
    80002a40:	4098                	lw	a4,0(s1)
    80002a42:	ff3716e3          	bne	a4,s3,80002a2e <iget+0x38>
    80002a46:	40d8                	lw	a4,4(s1)
    80002a48:	ff4713e3          	bne	a4,s4,80002a2e <iget+0x38>
      ip->ref++;
    80002a4c:	2785                	addiw	a5,a5,1
    80002a4e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a50:	00014517          	auipc	a0,0x14
    80002a54:	68850513          	addi	a0,a0,1672 # 800170d8 <itable>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	990080e7          	jalr	-1648(ra) # 800063e8 <release>
      return ip;
    80002a60:	8926                	mv	s2,s1
    80002a62:	a03d                	j	80002a90 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a64:	f7f9                	bnez	a5,80002a32 <iget+0x3c>
    80002a66:	8926                	mv	s2,s1
    80002a68:	b7e9                	j	80002a32 <iget+0x3c>
  if(empty == 0)
    80002a6a:	02090c63          	beqz	s2,80002aa2 <iget+0xac>
  ip->dev = dev;
    80002a6e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a72:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a76:	4785                	li	a5,1
    80002a78:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a7c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a80:	00014517          	auipc	a0,0x14
    80002a84:	65850513          	addi	a0,a0,1624 # 800170d8 <itable>
    80002a88:	00004097          	auipc	ra,0x4
    80002a8c:	960080e7          	jalr	-1696(ra) # 800063e8 <release>
}
    80002a90:	854a                	mv	a0,s2
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6942                	ld	s2,16(sp)
    80002a9a:	69a2                	ld	s3,8(sp)
    80002a9c:	6a02                	ld	s4,0(sp)
    80002a9e:	6145                	addi	sp,sp,48
    80002aa0:	8082                	ret
    panic("iget: no inodes");
    80002aa2:	00006517          	auipc	a0,0x6
    80002aa6:	b0650513          	addi	a0,a0,-1274 # 800085a8 <syscalls+0x1a8>
    80002aaa:	00003097          	auipc	ra,0x3
    80002aae:	352080e7          	jalr	850(ra) # 80005dfc <panic>

0000000080002ab2 <fsinit>:
fsinit(int dev) {
    80002ab2:	7179                	addi	sp,sp,-48
    80002ab4:	f406                	sd	ra,40(sp)
    80002ab6:	f022                	sd	s0,32(sp)
    80002ab8:	ec26                	sd	s1,24(sp)
    80002aba:	e84a                	sd	s2,16(sp)
    80002abc:	e44e                	sd	s3,8(sp)
    80002abe:	1800                	addi	s0,sp,48
    80002ac0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ac2:	4585                	li	a1,1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	a54080e7          	jalr	-1452(ra) # 80002518 <bread>
    80002acc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ace:	00014997          	auipc	s3,0x14
    80002ad2:	5ea98993          	addi	s3,s3,1514 # 800170b8 <sb>
    80002ad6:	02000613          	li	a2,32
    80002ada:	05850593          	addi	a1,a0,88
    80002ade:	854e                	mv	a0,s3
    80002ae0:	ffffd097          	auipc	ra,0xffffd
    80002ae4:	6f6080e7          	jalr	1782(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ae8:	8526                	mv	a0,s1
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	b5e080e7          	jalr	-1186(ra) # 80002648 <brelse>
  if(sb.magic != FSMAGIC)
    80002af2:	0009a703          	lw	a4,0(s3)
    80002af6:	102037b7          	lui	a5,0x10203
    80002afa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002afe:	02f71263          	bne	a4,a5,80002b22 <fsinit+0x70>
  initlog(dev, &sb);
    80002b02:	00014597          	auipc	a1,0x14
    80002b06:	5b658593          	addi	a1,a1,1462 # 800170b8 <sb>
    80002b0a:	854a                	mv	a0,s2
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	b4a080e7          	jalr	-1206(ra) # 80003656 <initlog>
}
    80002b14:	70a2                	ld	ra,40(sp)
    80002b16:	7402                	ld	s0,32(sp)
    80002b18:	64e2                	ld	s1,24(sp)
    80002b1a:	6942                	ld	s2,16(sp)
    80002b1c:	69a2                	ld	s3,8(sp)
    80002b1e:	6145                	addi	sp,sp,48
    80002b20:	8082                	ret
    panic("invalid file system");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	a9650513          	addi	a0,a0,-1386 # 800085b8 <syscalls+0x1b8>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	2d2080e7          	jalr	722(ra) # 80005dfc <panic>

0000000080002b32 <iinit>:
{
    80002b32:	7179                	addi	sp,sp,-48
    80002b34:	f406                	sd	ra,40(sp)
    80002b36:	f022                	sd	s0,32(sp)
    80002b38:	ec26                	sd	s1,24(sp)
    80002b3a:	e84a                	sd	s2,16(sp)
    80002b3c:	e44e                	sd	s3,8(sp)
    80002b3e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b40:	00006597          	auipc	a1,0x6
    80002b44:	a9058593          	addi	a1,a1,-1392 # 800085d0 <syscalls+0x1d0>
    80002b48:	00014517          	auipc	a0,0x14
    80002b4c:	59050513          	addi	a0,a0,1424 # 800170d8 <itable>
    80002b50:	00003097          	auipc	ra,0x3
    80002b54:	754080e7          	jalr	1876(ra) # 800062a4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b58:	00014497          	auipc	s1,0x14
    80002b5c:	5a848493          	addi	s1,s1,1448 # 80017100 <itable+0x28>
    80002b60:	00016997          	auipc	s3,0x16
    80002b64:	03098993          	addi	s3,s3,48 # 80018b90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b68:	00006917          	auipc	s2,0x6
    80002b6c:	a7090913          	addi	s2,s2,-1424 # 800085d8 <syscalls+0x1d8>
    80002b70:	85ca                	mv	a1,s2
    80002b72:	8526                	mv	a0,s1
    80002b74:	00001097          	auipc	ra,0x1
    80002b78:	e42080e7          	jalr	-446(ra) # 800039b6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b7c:	08848493          	addi	s1,s1,136
    80002b80:	ff3498e3          	bne	s1,s3,80002b70 <iinit+0x3e>
}
    80002b84:	70a2                	ld	ra,40(sp)
    80002b86:	7402                	ld	s0,32(sp)
    80002b88:	64e2                	ld	s1,24(sp)
    80002b8a:	6942                	ld	s2,16(sp)
    80002b8c:	69a2                	ld	s3,8(sp)
    80002b8e:	6145                	addi	sp,sp,48
    80002b90:	8082                	ret

0000000080002b92 <ialloc>:
{
    80002b92:	715d                	addi	sp,sp,-80
    80002b94:	e486                	sd	ra,72(sp)
    80002b96:	e0a2                	sd	s0,64(sp)
    80002b98:	fc26                	sd	s1,56(sp)
    80002b9a:	f84a                	sd	s2,48(sp)
    80002b9c:	f44e                	sd	s3,40(sp)
    80002b9e:	f052                	sd	s4,32(sp)
    80002ba0:	ec56                	sd	s5,24(sp)
    80002ba2:	e85a                	sd	s6,16(sp)
    80002ba4:	e45e                	sd	s7,8(sp)
    80002ba6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba8:	00014717          	auipc	a4,0x14
    80002bac:	51c72703          	lw	a4,1308(a4) # 800170c4 <sb+0xc>
    80002bb0:	4785                	li	a5,1
    80002bb2:	04e7fa63          	bgeu	a5,a4,80002c06 <ialloc+0x74>
    80002bb6:	8aaa                	mv	s5,a0
    80002bb8:	8bae                	mv	s7,a1
    80002bba:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bbc:	00014a17          	auipc	s4,0x14
    80002bc0:	4fca0a13          	addi	s4,s4,1276 # 800170b8 <sb>
    80002bc4:	00048b1b          	sext.w	s6,s1
    80002bc8:	0044d593          	srli	a1,s1,0x4
    80002bcc:	018a2783          	lw	a5,24(s4)
    80002bd0:	9dbd                	addw	a1,a1,a5
    80002bd2:	8556                	mv	a0,s5
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	944080e7          	jalr	-1724(ra) # 80002518 <bread>
    80002bdc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bde:	05850993          	addi	s3,a0,88
    80002be2:	00f4f793          	andi	a5,s1,15
    80002be6:	079a                	slli	a5,a5,0x6
    80002be8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bea:	00099783          	lh	a5,0(s3)
    80002bee:	c3a1                	beqz	a5,80002c2e <ialloc+0x9c>
    brelse(bp);
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	a58080e7          	jalr	-1448(ra) # 80002648 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf8:	0485                	addi	s1,s1,1
    80002bfa:	00ca2703          	lw	a4,12(s4)
    80002bfe:	0004879b          	sext.w	a5,s1
    80002c02:	fce7e1e3          	bltu	a5,a4,80002bc4 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c06:	00006517          	auipc	a0,0x6
    80002c0a:	9da50513          	addi	a0,a0,-1574 # 800085e0 <syscalls+0x1e0>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	238080e7          	jalr	568(ra) # 80005e46 <printf>
  return 0;
    80002c16:	4501                	li	a0,0
}
    80002c18:	60a6                	ld	ra,72(sp)
    80002c1a:	6406                	ld	s0,64(sp)
    80002c1c:	74e2                	ld	s1,56(sp)
    80002c1e:	7942                	ld	s2,48(sp)
    80002c20:	79a2                	ld	s3,40(sp)
    80002c22:	7a02                	ld	s4,32(sp)
    80002c24:	6ae2                	ld	s5,24(sp)
    80002c26:	6b42                	ld	s6,16(sp)
    80002c28:	6ba2                	ld	s7,8(sp)
    80002c2a:	6161                	addi	sp,sp,80
    80002c2c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c2e:	04000613          	li	a2,64
    80002c32:	4581                	li	a1,0
    80002c34:	854e                	mv	a0,s3
    80002c36:	ffffd097          	auipc	ra,0xffffd
    80002c3a:	544080e7          	jalr	1348(ra) # 8000017a <memset>
      dip->type = type;
    80002c3e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c42:	854a                	mv	a0,s2
    80002c44:	00001097          	auipc	ra,0x1
    80002c48:	c8e080e7          	jalr	-882(ra) # 800038d2 <log_write>
      brelse(bp);
    80002c4c:	854a                	mv	a0,s2
    80002c4e:	00000097          	auipc	ra,0x0
    80002c52:	9fa080e7          	jalr	-1542(ra) # 80002648 <brelse>
      return iget(dev, inum);
    80002c56:	85da                	mv	a1,s6
    80002c58:	8556                	mv	a0,s5
    80002c5a:	00000097          	auipc	ra,0x0
    80002c5e:	d9c080e7          	jalr	-612(ra) # 800029f6 <iget>
    80002c62:	bf5d                	j	80002c18 <ialloc+0x86>

0000000080002c64 <iupdate>:
{
    80002c64:	1101                	addi	sp,sp,-32
    80002c66:	ec06                	sd	ra,24(sp)
    80002c68:	e822                	sd	s0,16(sp)
    80002c6a:	e426                	sd	s1,8(sp)
    80002c6c:	e04a                	sd	s2,0(sp)
    80002c6e:	1000                	addi	s0,sp,32
    80002c70:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c72:	415c                	lw	a5,4(a0)
    80002c74:	0047d79b          	srliw	a5,a5,0x4
    80002c78:	00014597          	auipc	a1,0x14
    80002c7c:	4585a583          	lw	a1,1112(a1) # 800170d0 <sb+0x18>
    80002c80:	9dbd                	addw	a1,a1,a5
    80002c82:	4108                	lw	a0,0(a0)
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	894080e7          	jalr	-1900(ra) # 80002518 <bread>
    80002c8c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8e:	05850793          	addi	a5,a0,88
    80002c92:	40d8                	lw	a4,4(s1)
    80002c94:	8b3d                	andi	a4,a4,15
    80002c96:	071a                	slli	a4,a4,0x6
    80002c98:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c9a:	04449703          	lh	a4,68(s1)
    80002c9e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ca2:	04649703          	lh	a4,70(s1)
    80002ca6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002caa:	04849703          	lh	a4,72(s1)
    80002cae:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cb2:	04a49703          	lh	a4,74(s1)
    80002cb6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cba:	44f8                	lw	a4,76(s1)
    80002cbc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cbe:	03400613          	li	a2,52
    80002cc2:	05048593          	addi	a1,s1,80
    80002cc6:	00c78513          	addi	a0,a5,12
    80002cca:	ffffd097          	auipc	ra,0xffffd
    80002cce:	50c080e7          	jalr	1292(ra) # 800001d6 <memmove>
  log_write(bp);
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	bfe080e7          	jalr	-1026(ra) # 800038d2 <log_write>
  brelse(bp);
    80002cdc:	854a                	mv	a0,s2
    80002cde:	00000097          	auipc	ra,0x0
    80002ce2:	96a080e7          	jalr	-1686(ra) # 80002648 <brelse>
}
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6902                	ld	s2,0(sp)
    80002cee:	6105                	addi	sp,sp,32
    80002cf0:	8082                	ret

0000000080002cf2 <idup>:
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	1000                	addi	s0,sp,32
    80002cfc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cfe:	00014517          	auipc	a0,0x14
    80002d02:	3da50513          	addi	a0,a0,986 # 800170d8 <itable>
    80002d06:	00003097          	auipc	ra,0x3
    80002d0a:	62e080e7          	jalr	1582(ra) # 80006334 <acquire>
  ip->ref++;
    80002d0e:	449c                	lw	a5,8(s1)
    80002d10:	2785                	addiw	a5,a5,1
    80002d12:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d14:	00014517          	auipc	a0,0x14
    80002d18:	3c450513          	addi	a0,a0,964 # 800170d8 <itable>
    80002d1c:	00003097          	auipc	ra,0x3
    80002d20:	6cc080e7          	jalr	1740(ra) # 800063e8 <release>
}
    80002d24:	8526                	mv	a0,s1
    80002d26:	60e2                	ld	ra,24(sp)
    80002d28:	6442                	ld	s0,16(sp)
    80002d2a:	64a2                	ld	s1,8(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret

0000000080002d30 <ilock>:
{
    80002d30:	1101                	addi	sp,sp,-32
    80002d32:	ec06                	sd	ra,24(sp)
    80002d34:	e822                	sd	s0,16(sp)
    80002d36:	e426                	sd	s1,8(sp)
    80002d38:	e04a                	sd	s2,0(sp)
    80002d3a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d3c:	c115                	beqz	a0,80002d60 <ilock+0x30>
    80002d3e:	84aa                	mv	s1,a0
    80002d40:	451c                	lw	a5,8(a0)
    80002d42:	00f05f63          	blez	a5,80002d60 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d46:	0541                	addi	a0,a0,16
    80002d48:	00001097          	auipc	ra,0x1
    80002d4c:	ca8080e7          	jalr	-856(ra) # 800039f0 <acquiresleep>
  if(ip->valid == 0){
    80002d50:	40bc                	lw	a5,64(s1)
    80002d52:	cf99                	beqz	a5,80002d70 <ilock+0x40>
}
    80002d54:	60e2                	ld	ra,24(sp)
    80002d56:	6442                	ld	s0,16(sp)
    80002d58:	64a2                	ld	s1,8(sp)
    80002d5a:	6902                	ld	s2,0(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret
    panic("ilock");
    80002d60:	00006517          	auipc	a0,0x6
    80002d64:	89850513          	addi	a0,a0,-1896 # 800085f8 <syscalls+0x1f8>
    80002d68:	00003097          	auipc	ra,0x3
    80002d6c:	094080e7          	jalr	148(ra) # 80005dfc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d70:	40dc                	lw	a5,4(s1)
    80002d72:	0047d79b          	srliw	a5,a5,0x4
    80002d76:	00014597          	auipc	a1,0x14
    80002d7a:	35a5a583          	lw	a1,858(a1) # 800170d0 <sb+0x18>
    80002d7e:	9dbd                	addw	a1,a1,a5
    80002d80:	4088                	lw	a0,0(s1)
    80002d82:	fffff097          	auipc	ra,0xfffff
    80002d86:	796080e7          	jalr	1942(ra) # 80002518 <bread>
    80002d8a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d8c:	05850593          	addi	a1,a0,88
    80002d90:	40dc                	lw	a5,4(s1)
    80002d92:	8bbd                	andi	a5,a5,15
    80002d94:	079a                	slli	a5,a5,0x6
    80002d96:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d98:	00059783          	lh	a5,0(a1)
    80002d9c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002da0:	00259783          	lh	a5,2(a1)
    80002da4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002da8:	00459783          	lh	a5,4(a1)
    80002dac:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002db0:	00659783          	lh	a5,6(a1)
    80002db4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002db8:	459c                	lw	a5,8(a1)
    80002dba:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dbc:	03400613          	li	a2,52
    80002dc0:	05b1                	addi	a1,a1,12
    80002dc2:	05048513          	addi	a0,s1,80
    80002dc6:	ffffd097          	auipc	ra,0xffffd
    80002dca:	410080e7          	jalr	1040(ra) # 800001d6 <memmove>
    brelse(bp);
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	878080e7          	jalr	-1928(ra) # 80002648 <brelse>
    ip->valid = 1;
    80002dd8:	4785                	li	a5,1
    80002dda:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ddc:	04449783          	lh	a5,68(s1)
    80002de0:	fbb5                	bnez	a5,80002d54 <ilock+0x24>
      panic("ilock: no type");
    80002de2:	00006517          	auipc	a0,0x6
    80002de6:	81e50513          	addi	a0,a0,-2018 # 80008600 <syscalls+0x200>
    80002dea:	00003097          	auipc	ra,0x3
    80002dee:	012080e7          	jalr	18(ra) # 80005dfc <panic>

0000000080002df2 <iunlock>:
{
    80002df2:	1101                	addi	sp,sp,-32
    80002df4:	ec06                	sd	ra,24(sp)
    80002df6:	e822                	sd	s0,16(sp)
    80002df8:	e426                	sd	s1,8(sp)
    80002dfa:	e04a                	sd	s2,0(sp)
    80002dfc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dfe:	c905                	beqz	a0,80002e2e <iunlock+0x3c>
    80002e00:	84aa                	mv	s1,a0
    80002e02:	01050913          	addi	s2,a0,16
    80002e06:	854a                	mv	a0,s2
    80002e08:	00001097          	auipc	ra,0x1
    80002e0c:	c82080e7          	jalr	-894(ra) # 80003a8a <holdingsleep>
    80002e10:	cd19                	beqz	a0,80002e2e <iunlock+0x3c>
    80002e12:	449c                	lw	a5,8(s1)
    80002e14:	00f05d63          	blez	a5,80002e2e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	00001097          	auipc	ra,0x1
    80002e1e:	c2c080e7          	jalr	-980(ra) # 80003a46 <releasesleep>
}
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6902                	ld	s2,0(sp)
    80002e2a:	6105                	addi	sp,sp,32
    80002e2c:	8082                	ret
    panic("iunlock");
    80002e2e:	00005517          	auipc	a0,0x5
    80002e32:	7e250513          	addi	a0,a0,2018 # 80008610 <syscalls+0x210>
    80002e36:	00003097          	auipc	ra,0x3
    80002e3a:	fc6080e7          	jalr	-58(ra) # 80005dfc <panic>

0000000080002e3e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e3e:	7179                	addi	sp,sp,-48
    80002e40:	f406                	sd	ra,40(sp)
    80002e42:	f022                	sd	s0,32(sp)
    80002e44:	ec26                	sd	s1,24(sp)
    80002e46:	e84a                	sd	s2,16(sp)
    80002e48:	e44e                	sd	s3,8(sp)
    80002e4a:	e052                	sd	s4,0(sp)
    80002e4c:	1800                	addi	s0,sp,48
    80002e4e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e50:	05050493          	addi	s1,a0,80
    80002e54:	08050913          	addi	s2,a0,128
    80002e58:	a021                	j	80002e60 <itrunc+0x22>
    80002e5a:	0491                	addi	s1,s1,4
    80002e5c:	01248d63          	beq	s1,s2,80002e76 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e60:	408c                	lw	a1,0(s1)
    80002e62:	dde5                	beqz	a1,80002e5a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e64:	0009a503          	lw	a0,0(s3)
    80002e68:	00000097          	auipc	ra,0x0
    80002e6c:	8f6080e7          	jalr	-1802(ra) # 8000275e <bfree>
      ip->addrs[i] = 0;
    80002e70:	0004a023          	sw	zero,0(s1)
    80002e74:	b7dd                	j	80002e5a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e76:	0809a583          	lw	a1,128(s3)
    80002e7a:	e185                	bnez	a1,80002e9a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e7c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e80:	854e                	mv	a0,s3
    80002e82:	00000097          	auipc	ra,0x0
    80002e86:	de2080e7          	jalr	-542(ra) # 80002c64 <iupdate>
}
    80002e8a:	70a2                	ld	ra,40(sp)
    80002e8c:	7402                	ld	s0,32(sp)
    80002e8e:	64e2                	ld	s1,24(sp)
    80002e90:	6942                	ld	s2,16(sp)
    80002e92:	69a2                	ld	s3,8(sp)
    80002e94:	6a02                	ld	s4,0(sp)
    80002e96:	6145                	addi	sp,sp,48
    80002e98:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e9a:	0009a503          	lw	a0,0(s3)
    80002e9e:	fffff097          	auipc	ra,0xfffff
    80002ea2:	67a080e7          	jalr	1658(ra) # 80002518 <bread>
    80002ea6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ea8:	05850493          	addi	s1,a0,88
    80002eac:	45850913          	addi	s2,a0,1112
    80002eb0:	a021                	j	80002eb8 <itrunc+0x7a>
    80002eb2:	0491                	addi	s1,s1,4
    80002eb4:	01248b63          	beq	s1,s2,80002eca <itrunc+0x8c>
      if(a[j])
    80002eb8:	408c                	lw	a1,0(s1)
    80002eba:	dde5                	beqz	a1,80002eb2 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002ebc:	0009a503          	lw	a0,0(s3)
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	89e080e7          	jalr	-1890(ra) # 8000275e <bfree>
    80002ec8:	b7ed                	j	80002eb2 <itrunc+0x74>
    brelse(bp);
    80002eca:	8552                	mv	a0,s4
    80002ecc:	fffff097          	auipc	ra,0xfffff
    80002ed0:	77c080e7          	jalr	1916(ra) # 80002648 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ed4:	0809a583          	lw	a1,128(s3)
    80002ed8:	0009a503          	lw	a0,0(s3)
    80002edc:	00000097          	auipc	ra,0x0
    80002ee0:	882080e7          	jalr	-1918(ra) # 8000275e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ee4:	0809a023          	sw	zero,128(s3)
    80002ee8:	bf51                	j	80002e7c <itrunc+0x3e>

0000000080002eea <iput>:
{
    80002eea:	1101                	addi	sp,sp,-32
    80002eec:	ec06                	sd	ra,24(sp)
    80002eee:	e822                	sd	s0,16(sp)
    80002ef0:	e426                	sd	s1,8(sp)
    80002ef2:	e04a                	sd	s2,0(sp)
    80002ef4:	1000                	addi	s0,sp,32
    80002ef6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ef8:	00014517          	auipc	a0,0x14
    80002efc:	1e050513          	addi	a0,a0,480 # 800170d8 <itable>
    80002f00:	00003097          	auipc	ra,0x3
    80002f04:	434080e7          	jalr	1076(ra) # 80006334 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f08:	4498                	lw	a4,8(s1)
    80002f0a:	4785                	li	a5,1
    80002f0c:	02f70363          	beq	a4,a5,80002f32 <iput+0x48>
  ip->ref--;
    80002f10:	449c                	lw	a5,8(s1)
    80002f12:	37fd                	addiw	a5,a5,-1
    80002f14:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f16:	00014517          	auipc	a0,0x14
    80002f1a:	1c250513          	addi	a0,a0,450 # 800170d8 <itable>
    80002f1e:	00003097          	auipc	ra,0x3
    80002f22:	4ca080e7          	jalr	1226(ra) # 800063e8 <release>
}
    80002f26:	60e2                	ld	ra,24(sp)
    80002f28:	6442                	ld	s0,16(sp)
    80002f2a:	64a2                	ld	s1,8(sp)
    80002f2c:	6902                	ld	s2,0(sp)
    80002f2e:	6105                	addi	sp,sp,32
    80002f30:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f32:	40bc                	lw	a5,64(s1)
    80002f34:	dff1                	beqz	a5,80002f10 <iput+0x26>
    80002f36:	04a49783          	lh	a5,74(s1)
    80002f3a:	fbf9                	bnez	a5,80002f10 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f3c:	01048913          	addi	s2,s1,16
    80002f40:	854a                	mv	a0,s2
    80002f42:	00001097          	auipc	ra,0x1
    80002f46:	aae080e7          	jalr	-1362(ra) # 800039f0 <acquiresleep>
    release(&itable.lock);
    80002f4a:	00014517          	auipc	a0,0x14
    80002f4e:	18e50513          	addi	a0,a0,398 # 800170d8 <itable>
    80002f52:	00003097          	auipc	ra,0x3
    80002f56:	496080e7          	jalr	1174(ra) # 800063e8 <release>
    itrunc(ip);
    80002f5a:	8526                	mv	a0,s1
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	ee2080e7          	jalr	-286(ra) # 80002e3e <itrunc>
    ip->type = 0;
    80002f64:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f68:	8526                	mv	a0,s1
    80002f6a:	00000097          	auipc	ra,0x0
    80002f6e:	cfa080e7          	jalr	-774(ra) # 80002c64 <iupdate>
    ip->valid = 0;
    80002f72:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f76:	854a                	mv	a0,s2
    80002f78:	00001097          	auipc	ra,0x1
    80002f7c:	ace080e7          	jalr	-1330(ra) # 80003a46 <releasesleep>
    acquire(&itable.lock);
    80002f80:	00014517          	auipc	a0,0x14
    80002f84:	15850513          	addi	a0,a0,344 # 800170d8 <itable>
    80002f88:	00003097          	auipc	ra,0x3
    80002f8c:	3ac080e7          	jalr	940(ra) # 80006334 <acquire>
    80002f90:	b741                	j	80002f10 <iput+0x26>

0000000080002f92 <iunlockput>:
{
    80002f92:	1101                	addi	sp,sp,-32
    80002f94:	ec06                	sd	ra,24(sp)
    80002f96:	e822                	sd	s0,16(sp)
    80002f98:	e426                	sd	s1,8(sp)
    80002f9a:	1000                	addi	s0,sp,32
    80002f9c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f9e:	00000097          	auipc	ra,0x0
    80002fa2:	e54080e7          	jalr	-428(ra) # 80002df2 <iunlock>
  iput(ip);
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	00000097          	auipc	ra,0x0
    80002fac:	f42080e7          	jalr	-190(ra) # 80002eea <iput>
}
    80002fb0:	60e2                	ld	ra,24(sp)
    80002fb2:	6442                	ld	s0,16(sp)
    80002fb4:	64a2                	ld	s1,8(sp)
    80002fb6:	6105                	addi	sp,sp,32
    80002fb8:	8082                	ret

0000000080002fba <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fba:	1141                	addi	sp,sp,-16
    80002fbc:	e422                	sd	s0,8(sp)
    80002fbe:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fc0:	411c                	lw	a5,0(a0)
    80002fc2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fc4:	415c                	lw	a5,4(a0)
    80002fc6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fc8:	04451783          	lh	a5,68(a0)
    80002fcc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fd0:	04a51783          	lh	a5,74(a0)
    80002fd4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fd8:	04c56783          	lwu	a5,76(a0)
    80002fdc:	e99c                	sd	a5,16(a1)
}
    80002fde:	6422                	ld	s0,8(sp)
    80002fe0:	0141                	addi	sp,sp,16
    80002fe2:	8082                	ret

0000000080002fe4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe4:	457c                	lw	a5,76(a0)
    80002fe6:	0ed7e963          	bltu	a5,a3,800030d8 <readi+0xf4>
{
    80002fea:	7159                	addi	sp,sp,-112
    80002fec:	f486                	sd	ra,104(sp)
    80002fee:	f0a2                	sd	s0,96(sp)
    80002ff0:	eca6                	sd	s1,88(sp)
    80002ff2:	e8ca                	sd	s2,80(sp)
    80002ff4:	e4ce                	sd	s3,72(sp)
    80002ff6:	e0d2                	sd	s4,64(sp)
    80002ff8:	fc56                	sd	s5,56(sp)
    80002ffa:	f85a                	sd	s6,48(sp)
    80002ffc:	f45e                	sd	s7,40(sp)
    80002ffe:	f062                	sd	s8,32(sp)
    80003000:	ec66                	sd	s9,24(sp)
    80003002:	e86a                	sd	s10,16(sp)
    80003004:	e46e                	sd	s11,8(sp)
    80003006:	1880                	addi	s0,sp,112
    80003008:	8b2a                	mv	s6,a0
    8000300a:	8bae                	mv	s7,a1
    8000300c:	8a32                	mv	s4,a2
    8000300e:	84b6                	mv	s1,a3
    80003010:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003012:	9f35                	addw	a4,a4,a3
    return 0;
    80003014:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003016:	0ad76063          	bltu	a4,a3,800030b6 <readi+0xd2>
  if(off + n > ip->size)
    8000301a:	00e7f463          	bgeu	a5,a4,80003022 <readi+0x3e>
    n = ip->size - off;
    8000301e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003022:	0a0a8963          	beqz	s5,800030d4 <readi+0xf0>
    80003026:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003028:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000302c:	5c7d                	li	s8,-1
    8000302e:	a82d                	j	80003068 <readi+0x84>
    80003030:	020d1d93          	slli	s11,s10,0x20
    80003034:	020ddd93          	srli	s11,s11,0x20
    80003038:	05890613          	addi	a2,s2,88
    8000303c:	86ee                	mv	a3,s11
    8000303e:	963a                	add	a2,a2,a4
    80003040:	85d2                	mv	a1,s4
    80003042:	855e                	mv	a0,s7
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	a2c080e7          	jalr	-1492(ra) # 80001a70 <either_copyout>
    8000304c:	05850d63          	beq	a0,s8,800030a6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003050:	854a                	mv	a0,s2
    80003052:	fffff097          	auipc	ra,0xfffff
    80003056:	5f6080e7          	jalr	1526(ra) # 80002648 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000305a:	013d09bb          	addw	s3,s10,s3
    8000305e:	009d04bb          	addw	s1,s10,s1
    80003062:	9a6e                	add	s4,s4,s11
    80003064:	0559f763          	bgeu	s3,s5,800030b2 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003068:	00a4d59b          	srliw	a1,s1,0xa
    8000306c:	855a                	mv	a0,s6
    8000306e:	00000097          	auipc	ra,0x0
    80003072:	89e080e7          	jalr	-1890(ra) # 8000290c <bmap>
    80003076:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000307a:	cd85                	beqz	a1,800030b2 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000307c:	000b2503          	lw	a0,0(s6)
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	498080e7          	jalr	1176(ra) # 80002518 <bread>
    80003088:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000308a:	3ff4f713          	andi	a4,s1,1023
    8000308e:	40ec87bb          	subw	a5,s9,a4
    80003092:	413a86bb          	subw	a3,s5,s3
    80003096:	8d3e                	mv	s10,a5
    80003098:	2781                	sext.w	a5,a5
    8000309a:	0006861b          	sext.w	a2,a3
    8000309e:	f8f679e3          	bgeu	a2,a5,80003030 <readi+0x4c>
    800030a2:	8d36                	mv	s10,a3
    800030a4:	b771                	j	80003030 <readi+0x4c>
      brelse(bp);
    800030a6:	854a                	mv	a0,s2
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	5a0080e7          	jalr	1440(ra) # 80002648 <brelse>
      tot = -1;
    800030b0:	59fd                	li	s3,-1
  }
  return tot;
    800030b2:	0009851b          	sext.w	a0,s3
}
    800030b6:	70a6                	ld	ra,104(sp)
    800030b8:	7406                	ld	s0,96(sp)
    800030ba:	64e6                	ld	s1,88(sp)
    800030bc:	6946                	ld	s2,80(sp)
    800030be:	69a6                	ld	s3,72(sp)
    800030c0:	6a06                	ld	s4,64(sp)
    800030c2:	7ae2                	ld	s5,56(sp)
    800030c4:	7b42                	ld	s6,48(sp)
    800030c6:	7ba2                	ld	s7,40(sp)
    800030c8:	7c02                	ld	s8,32(sp)
    800030ca:	6ce2                	ld	s9,24(sp)
    800030cc:	6d42                	ld	s10,16(sp)
    800030ce:	6da2                	ld	s11,8(sp)
    800030d0:	6165                	addi	sp,sp,112
    800030d2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d4:	89d6                	mv	s3,s5
    800030d6:	bff1                	j	800030b2 <readi+0xce>
    return 0;
    800030d8:	4501                	li	a0,0
}
    800030da:	8082                	ret

00000000800030dc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030dc:	457c                	lw	a5,76(a0)
    800030de:	10d7e863          	bltu	a5,a3,800031ee <writei+0x112>
{
    800030e2:	7159                	addi	sp,sp,-112
    800030e4:	f486                	sd	ra,104(sp)
    800030e6:	f0a2                	sd	s0,96(sp)
    800030e8:	eca6                	sd	s1,88(sp)
    800030ea:	e8ca                	sd	s2,80(sp)
    800030ec:	e4ce                	sd	s3,72(sp)
    800030ee:	e0d2                	sd	s4,64(sp)
    800030f0:	fc56                	sd	s5,56(sp)
    800030f2:	f85a                	sd	s6,48(sp)
    800030f4:	f45e                	sd	s7,40(sp)
    800030f6:	f062                	sd	s8,32(sp)
    800030f8:	ec66                	sd	s9,24(sp)
    800030fa:	e86a                	sd	s10,16(sp)
    800030fc:	e46e                	sd	s11,8(sp)
    800030fe:	1880                	addi	s0,sp,112
    80003100:	8aaa                	mv	s5,a0
    80003102:	8bae                	mv	s7,a1
    80003104:	8a32                	mv	s4,a2
    80003106:	8936                	mv	s2,a3
    80003108:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000310a:	00e687bb          	addw	a5,a3,a4
    8000310e:	0ed7e263          	bltu	a5,a3,800031f2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003112:	00043737          	lui	a4,0x43
    80003116:	0ef76063          	bltu	a4,a5,800031f6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000311a:	0c0b0863          	beqz	s6,800031ea <writei+0x10e>
    8000311e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003120:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003124:	5c7d                	li	s8,-1
    80003126:	a091                	j	8000316a <writei+0x8e>
    80003128:	020d1d93          	slli	s11,s10,0x20
    8000312c:	020ddd93          	srli	s11,s11,0x20
    80003130:	05848513          	addi	a0,s1,88
    80003134:	86ee                	mv	a3,s11
    80003136:	8652                	mv	a2,s4
    80003138:	85de                	mv	a1,s7
    8000313a:	953a                	add	a0,a0,a4
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	98a080e7          	jalr	-1654(ra) # 80001ac6 <either_copyin>
    80003144:	07850263          	beq	a0,s8,800031a8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003148:	8526                	mv	a0,s1
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	788080e7          	jalr	1928(ra) # 800038d2 <log_write>
    brelse(bp);
    80003152:	8526                	mv	a0,s1
    80003154:	fffff097          	auipc	ra,0xfffff
    80003158:	4f4080e7          	jalr	1268(ra) # 80002648 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000315c:	013d09bb          	addw	s3,s10,s3
    80003160:	012d093b          	addw	s2,s10,s2
    80003164:	9a6e                	add	s4,s4,s11
    80003166:	0569f663          	bgeu	s3,s6,800031b2 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000316a:	00a9559b          	srliw	a1,s2,0xa
    8000316e:	8556                	mv	a0,s5
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	79c080e7          	jalr	1948(ra) # 8000290c <bmap>
    80003178:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000317c:	c99d                	beqz	a1,800031b2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000317e:	000aa503          	lw	a0,0(s5)
    80003182:	fffff097          	auipc	ra,0xfffff
    80003186:	396080e7          	jalr	918(ra) # 80002518 <bread>
    8000318a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000318c:	3ff97713          	andi	a4,s2,1023
    80003190:	40ec87bb          	subw	a5,s9,a4
    80003194:	413b06bb          	subw	a3,s6,s3
    80003198:	8d3e                	mv	s10,a5
    8000319a:	2781                	sext.w	a5,a5
    8000319c:	0006861b          	sext.w	a2,a3
    800031a0:	f8f674e3          	bgeu	a2,a5,80003128 <writei+0x4c>
    800031a4:	8d36                	mv	s10,a3
    800031a6:	b749                	j	80003128 <writei+0x4c>
      brelse(bp);
    800031a8:	8526                	mv	a0,s1
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	49e080e7          	jalr	1182(ra) # 80002648 <brelse>
  }

  if(off > ip->size)
    800031b2:	04caa783          	lw	a5,76(s5)
    800031b6:	0127f463          	bgeu	a5,s2,800031be <writei+0xe2>
    ip->size = off;
    800031ba:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031be:	8556                	mv	a0,s5
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	aa4080e7          	jalr	-1372(ra) # 80002c64 <iupdate>

  return tot;
    800031c8:	0009851b          	sext.w	a0,s3
}
    800031cc:	70a6                	ld	ra,104(sp)
    800031ce:	7406                	ld	s0,96(sp)
    800031d0:	64e6                	ld	s1,88(sp)
    800031d2:	6946                	ld	s2,80(sp)
    800031d4:	69a6                	ld	s3,72(sp)
    800031d6:	6a06                	ld	s4,64(sp)
    800031d8:	7ae2                	ld	s5,56(sp)
    800031da:	7b42                	ld	s6,48(sp)
    800031dc:	7ba2                	ld	s7,40(sp)
    800031de:	7c02                	ld	s8,32(sp)
    800031e0:	6ce2                	ld	s9,24(sp)
    800031e2:	6d42                	ld	s10,16(sp)
    800031e4:	6da2                	ld	s11,8(sp)
    800031e6:	6165                	addi	sp,sp,112
    800031e8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ea:	89da                	mv	s3,s6
    800031ec:	bfc9                	j	800031be <writei+0xe2>
    return -1;
    800031ee:	557d                	li	a0,-1
}
    800031f0:	8082                	ret
    return -1;
    800031f2:	557d                	li	a0,-1
    800031f4:	bfe1                	j	800031cc <writei+0xf0>
    return -1;
    800031f6:	557d                	li	a0,-1
    800031f8:	bfd1                	j	800031cc <writei+0xf0>

00000000800031fa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031fa:	1141                	addi	sp,sp,-16
    800031fc:	e406                	sd	ra,8(sp)
    800031fe:	e022                	sd	s0,0(sp)
    80003200:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003202:	4639                	li	a2,14
    80003204:	ffffd097          	auipc	ra,0xffffd
    80003208:	046080e7          	jalr	70(ra) # 8000024a <strncmp>
}
    8000320c:	60a2                	ld	ra,8(sp)
    8000320e:	6402                	ld	s0,0(sp)
    80003210:	0141                	addi	sp,sp,16
    80003212:	8082                	ret

0000000080003214 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003214:	7139                	addi	sp,sp,-64
    80003216:	fc06                	sd	ra,56(sp)
    80003218:	f822                	sd	s0,48(sp)
    8000321a:	f426                	sd	s1,40(sp)
    8000321c:	f04a                	sd	s2,32(sp)
    8000321e:	ec4e                	sd	s3,24(sp)
    80003220:	e852                	sd	s4,16(sp)
    80003222:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003224:	04451703          	lh	a4,68(a0)
    80003228:	4785                	li	a5,1
    8000322a:	00f71a63          	bne	a4,a5,8000323e <dirlookup+0x2a>
    8000322e:	892a                	mv	s2,a0
    80003230:	89ae                	mv	s3,a1
    80003232:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003234:	457c                	lw	a5,76(a0)
    80003236:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003238:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000323a:	e79d                	bnez	a5,80003268 <dirlookup+0x54>
    8000323c:	a8a5                	j	800032b4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000323e:	00005517          	auipc	a0,0x5
    80003242:	3da50513          	addi	a0,a0,986 # 80008618 <syscalls+0x218>
    80003246:	00003097          	auipc	ra,0x3
    8000324a:	bb6080e7          	jalr	-1098(ra) # 80005dfc <panic>
      panic("dirlookup read");
    8000324e:	00005517          	auipc	a0,0x5
    80003252:	3e250513          	addi	a0,a0,994 # 80008630 <syscalls+0x230>
    80003256:	00003097          	auipc	ra,0x3
    8000325a:	ba6080e7          	jalr	-1114(ra) # 80005dfc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325e:	24c1                	addiw	s1,s1,16
    80003260:	04c92783          	lw	a5,76(s2)
    80003264:	04f4f763          	bgeu	s1,a5,800032b2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003268:	4741                	li	a4,16
    8000326a:	86a6                	mv	a3,s1
    8000326c:	fc040613          	addi	a2,s0,-64
    80003270:	4581                	li	a1,0
    80003272:	854a                	mv	a0,s2
    80003274:	00000097          	auipc	ra,0x0
    80003278:	d70080e7          	jalr	-656(ra) # 80002fe4 <readi>
    8000327c:	47c1                	li	a5,16
    8000327e:	fcf518e3          	bne	a0,a5,8000324e <dirlookup+0x3a>
    if(de.inum == 0)
    80003282:	fc045783          	lhu	a5,-64(s0)
    80003286:	dfe1                	beqz	a5,8000325e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003288:	fc240593          	addi	a1,s0,-62
    8000328c:	854e                	mv	a0,s3
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	f6c080e7          	jalr	-148(ra) # 800031fa <namecmp>
    80003296:	f561                	bnez	a0,8000325e <dirlookup+0x4a>
      if(poff)
    80003298:	000a0463          	beqz	s4,800032a0 <dirlookup+0x8c>
        *poff = off;
    8000329c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032a0:	fc045583          	lhu	a1,-64(s0)
    800032a4:	00092503          	lw	a0,0(s2)
    800032a8:	fffff097          	auipc	ra,0xfffff
    800032ac:	74e080e7          	jalr	1870(ra) # 800029f6 <iget>
    800032b0:	a011                	j	800032b4 <dirlookup+0xa0>
  return 0;
    800032b2:	4501                	li	a0,0
}
    800032b4:	70e2                	ld	ra,56(sp)
    800032b6:	7442                	ld	s0,48(sp)
    800032b8:	74a2                	ld	s1,40(sp)
    800032ba:	7902                	ld	s2,32(sp)
    800032bc:	69e2                	ld	s3,24(sp)
    800032be:	6a42                	ld	s4,16(sp)
    800032c0:	6121                	addi	sp,sp,64
    800032c2:	8082                	ret

00000000800032c4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032c4:	711d                	addi	sp,sp,-96
    800032c6:	ec86                	sd	ra,88(sp)
    800032c8:	e8a2                	sd	s0,80(sp)
    800032ca:	e4a6                	sd	s1,72(sp)
    800032cc:	e0ca                	sd	s2,64(sp)
    800032ce:	fc4e                	sd	s3,56(sp)
    800032d0:	f852                	sd	s4,48(sp)
    800032d2:	f456                	sd	s5,40(sp)
    800032d4:	f05a                	sd	s6,32(sp)
    800032d6:	ec5e                	sd	s7,24(sp)
    800032d8:	e862                	sd	s8,16(sp)
    800032da:	e466                	sd	s9,8(sp)
    800032dc:	e06a                	sd	s10,0(sp)
    800032de:	1080                	addi	s0,sp,96
    800032e0:	84aa                	mv	s1,a0
    800032e2:	8b2e                	mv	s6,a1
    800032e4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032e6:	00054703          	lbu	a4,0(a0)
    800032ea:	02f00793          	li	a5,47
    800032ee:	02f70363          	beq	a4,a5,80003314 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032f2:	ffffe097          	auipc	ra,0xffffe
    800032f6:	c4c080e7          	jalr	-948(ra) # 80000f3e <myproc>
    800032fa:	15853503          	ld	a0,344(a0)
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	9f4080e7          	jalr	-1548(ra) # 80002cf2 <idup>
    80003306:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003308:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000330c:	4cb5                	li	s9,13
  len = path - s;
    8000330e:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003310:	4c05                	li	s8,1
    80003312:	a87d                	j	800033d0 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003314:	4585                	li	a1,1
    80003316:	4505                	li	a0,1
    80003318:	fffff097          	auipc	ra,0xfffff
    8000331c:	6de080e7          	jalr	1758(ra) # 800029f6 <iget>
    80003320:	8a2a                	mv	s4,a0
    80003322:	b7dd                	j	80003308 <namex+0x44>
      iunlockput(ip);
    80003324:	8552                	mv	a0,s4
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	c6c080e7          	jalr	-916(ra) # 80002f92 <iunlockput>
      return 0;
    8000332e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003330:	8552                	mv	a0,s4
    80003332:	60e6                	ld	ra,88(sp)
    80003334:	6446                	ld	s0,80(sp)
    80003336:	64a6                	ld	s1,72(sp)
    80003338:	6906                	ld	s2,64(sp)
    8000333a:	79e2                	ld	s3,56(sp)
    8000333c:	7a42                	ld	s4,48(sp)
    8000333e:	7aa2                	ld	s5,40(sp)
    80003340:	7b02                	ld	s6,32(sp)
    80003342:	6be2                	ld	s7,24(sp)
    80003344:	6c42                	ld	s8,16(sp)
    80003346:	6ca2                	ld	s9,8(sp)
    80003348:	6d02                	ld	s10,0(sp)
    8000334a:	6125                	addi	sp,sp,96
    8000334c:	8082                	ret
      iunlock(ip);
    8000334e:	8552                	mv	a0,s4
    80003350:	00000097          	auipc	ra,0x0
    80003354:	aa2080e7          	jalr	-1374(ra) # 80002df2 <iunlock>
      return ip;
    80003358:	bfe1                	j	80003330 <namex+0x6c>
      iunlockput(ip);
    8000335a:	8552                	mv	a0,s4
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	c36080e7          	jalr	-970(ra) # 80002f92 <iunlockput>
      return 0;
    80003364:	8a4e                	mv	s4,s3
    80003366:	b7e9                	j	80003330 <namex+0x6c>
  len = path - s;
    80003368:	40998633          	sub	a2,s3,s1
    8000336c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003370:	09acd863          	bge	s9,s10,80003400 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003374:	4639                	li	a2,14
    80003376:	85a6                	mv	a1,s1
    80003378:	8556                	mv	a0,s5
    8000337a:	ffffd097          	auipc	ra,0xffffd
    8000337e:	e5c080e7          	jalr	-420(ra) # 800001d6 <memmove>
    80003382:	84ce                	mv	s1,s3
  while(*path == '/')
    80003384:	0004c783          	lbu	a5,0(s1)
    80003388:	01279763          	bne	a5,s2,80003396 <namex+0xd2>
    path++;
    8000338c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000338e:	0004c783          	lbu	a5,0(s1)
    80003392:	ff278de3          	beq	a5,s2,8000338c <namex+0xc8>
    ilock(ip);
    80003396:	8552                	mv	a0,s4
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	998080e7          	jalr	-1640(ra) # 80002d30 <ilock>
    if(ip->type != T_DIR){
    800033a0:	044a1783          	lh	a5,68(s4)
    800033a4:	f98790e3          	bne	a5,s8,80003324 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800033a8:	000b0563          	beqz	s6,800033b2 <namex+0xee>
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	dfd9                	beqz	a5,8000334e <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033b2:	865e                	mv	a2,s7
    800033b4:	85d6                	mv	a1,s5
    800033b6:	8552                	mv	a0,s4
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	e5c080e7          	jalr	-420(ra) # 80003214 <dirlookup>
    800033c0:	89aa                	mv	s3,a0
    800033c2:	dd41                	beqz	a0,8000335a <namex+0x96>
    iunlockput(ip);
    800033c4:	8552                	mv	a0,s4
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	bcc080e7          	jalr	-1076(ra) # 80002f92 <iunlockput>
    ip = next;
    800033ce:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033d0:	0004c783          	lbu	a5,0(s1)
    800033d4:	01279763          	bne	a5,s2,800033e2 <namex+0x11e>
    path++;
    800033d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033da:	0004c783          	lbu	a5,0(s1)
    800033de:	ff278de3          	beq	a5,s2,800033d8 <namex+0x114>
  if(*path == 0)
    800033e2:	cb9d                	beqz	a5,80003418 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033e4:	0004c783          	lbu	a5,0(s1)
    800033e8:	89a6                	mv	s3,s1
  len = path - s;
    800033ea:	8d5e                	mv	s10,s7
    800033ec:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ee:	01278963          	beq	a5,s2,80003400 <namex+0x13c>
    800033f2:	dbbd                	beqz	a5,80003368 <namex+0xa4>
    path++;
    800033f4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033f6:	0009c783          	lbu	a5,0(s3)
    800033fa:	ff279ce3          	bne	a5,s2,800033f2 <namex+0x12e>
    800033fe:	b7ad                	j	80003368 <namex+0xa4>
    memmove(name, s, len);
    80003400:	2601                	sext.w	a2,a2
    80003402:	85a6                	mv	a1,s1
    80003404:	8556                	mv	a0,s5
    80003406:	ffffd097          	auipc	ra,0xffffd
    8000340a:	dd0080e7          	jalr	-560(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000340e:	9d56                	add	s10,s10,s5
    80003410:	000d0023          	sb	zero,0(s10)
    80003414:	84ce                	mv	s1,s3
    80003416:	b7bd                	j	80003384 <namex+0xc0>
  if(nameiparent){
    80003418:	f00b0ce3          	beqz	s6,80003330 <namex+0x6c>
    iput(ip);
    8000341c:	8552                	mv	a0,s4
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	acc080e7          	jalr	-1332(ra) # 80002eea <iput>
    return 0;
    80003426:	4a01                	li	s4,0
    80003428:	b721                	j	80003330 <namex+0x6c>

000000008000342a <dirlink>:
{
    8000342a:	7139                	addi	sp,sp,-64
    8000342c:	fc06                	sd	ra,56(sp)
    8000342e:	f822                	sd	s0,48(sp)
    80003430:	f426                	sd	s1,40(sp)
    80003432:	f04a                	sd	s2,32(sp)
    80003434:	ec4e                	sd	s3,24(sp)
    80003436:	e852                	sd	s4,16(sp)
    80003438:	0080                	addi	s0,sp,64
    8000343a:	892a                	mv	s2,a0
    8000343c:	8a2e                	mv	s4,a1
    8000343e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003440:	4601                	li	a2,0
    80003442:	00000097          	auipc	ra,0x0
    80003446:	dd2080e7          	jalr	-558(ra) # 80003214 <dirlookup>
    8000344a:	e93d                	bnez	a0,800034c0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000344c:	04c92483          	lw	s1,76(s2)
    80003450:	c49d                	beqz	s1,8000347e <dirlink+0x54>
    80003452:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003454:	4741                	li	a4,16
    80003456:	86a6                	mv	a3,s1
    80003458:	fc040613          	addi	a2,s0,-64
    8000345c:	4581                	li	a1,0
    8000345e:	854a                	mv	a0,s2
    80003460:	00000097          	auipc	ra,0x0
    80003464:	b84080e7          	jalr	-1148(ra) # 80002fe4 <readi>
    80003468:	47c1                	li	a5,16
    8000346a:	06f51163          	bne	a0,a5,800034cc <dirlink+0xa2>
    if(de.inum == 0)
    8000346e:	fc045783          	lhu	a5,-64(s0)
    80003472:	c791                	beqz	a5,8000347e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003474:	24c1                	addiw	s1,s1,16
    80003476:	04c92783          	lw	a5,76(s2)
    8000347a:	fcf4ede3          	bltu	s1,a5,80003454 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000347e:	4639                	li	a2,14
    80003480:	85d2                	mv	a1,s4
    80003482:	fc240513          	addi	a0,s0,-62
    80003486:	ffffd097          	auipc	ra,0xffffd
    8000348a:	e00080e7          	jalr	-512(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000348e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003492:	4741                	li	a4,16
    80003494:	86a6                	mv	a3,s1
    80003496:	fc040613          	addi	a2,s0,-64
    8000349a:	4581                	li	a1,0
    8000349c:	854a                	mv	a0,s2
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	c3e080e7          	jalr	-962(ra) # 800030dc <writei>
    800034a6:	1541                	addi	a0,a0,-16
    800034a8:	00a03533          	snez	a0,a0
    800034ac:	40a00533          	neg	a0,a0
}
    800034b0:	70e2                	ld	ra,56(sp)
    800034b2:	7442                	ld	s0,48(sp)
    800034b4:	74a2                	ld	s1,40(sp)
    800034b6:	7902                	ld	s2,32(sp)
    800034b8:	69e2                	ld	s3,24(sp)
    800034ba:	6a42                	ld	s4,16(sp)
    800034bc:	6121                	addi	sp,sp,64
    800034be:	8082                	ret
    iput(ip);
    800034c0:	00000097          	auipc	ra,0x0
    800034c4:	a2a080e7          	jalr	-1494(ra) # 80002eea <iput>
    return -1;
    800034c8:	557d                	li	a0,-1
    800034ca:	b7dd                	j	800034b0 <dirlink+0x86>
      panic("dirlink read");
    800034cc:	00005517          	auipc	a0,0x5
    800034d0:	17450513          	addi	a0,a0,372 # 80008640 <syscalls+0x240>
    800034d4:	00003097          	auipc	ra,0x3
    800034d8:	928080e7          	jalr	-1752(ra) # 80005dfc <panic>

00000000800034dc <namei>:

struct inode*
namei(char *path)
{
    800034dc:	1101                	addi	sp,sp,-32
    800034de:	ec06                	sd	ra,24(sp)
    800034e0:	e822                	sd	s0,16(sp)
    800034e2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034e4:	fe040613          	addi	a2,s0,-32
    800034e8:	4581                	li	a1,0
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	dda080e7          	jalr	-550(ra) # 800032c4 <namex>
}
    800034f2:	60e2                	ld	ra,24(sp)
    800034f4:	6442                	ld	s0,16(sp)
    800034f6:	6105                	addi	sp,sp,32
    800034f8:	8082                	ret

00000000800034fa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034fa:	1141                	addi	sp,sp,-16
    800034fc:	e406                	sd	ra,8(sp)
    800034fe:	e022                	sd	s0,0(sp)
    80003500:	0800                	addi	s0,sp,16
    80003502:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003504:	4585                	li	a1,1
    80003506:	00000097          	auipc	ra,0x0
    8000350a:	dbe080e7          	jalr	-578(ra) # 800032c4 <namex>
}
    8000350e:	60a2                	ld	ra,8(sp)
    80003510:	6402                	ld	s0,0(sp)
    80003512:	0141                	addi	sp,sp,16
    80003514:	8082                	ret

0000000080003516 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	e426                	sd	s1,8(sp)
    8000351e:	e04a                	sd	s2,0(sp)
    80003520:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003522:	00015917          	auipc	s2,0x15
    80003526:	65e90913          	addi	s2,s2,1630 # 80018b80 <log>
    8000352a:	01892583          	lw	a1,24(s2)
    8000352e:	02892503          	lw	a0,40(s2)
    80003532:	fffff097          	auipc	ra,0xfffff
    80003536:	fe6080e7          	jalr	-26(ra) # 80002518 <bread>
    8000353a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000353c:	02c92683          	lw	a3,44(s2)
    80003540:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	02d05863          	blez	a3,80003572 <write_head+0x5c>
    80003546:	00015797          	auipc	a5,0x15
    8000354a:	66a78793          	addi	a5,a5,1642 # 80018bb0 <log+0x30>
    8000354e:	05c50713          	addi	a4,a0,92
    80003552:	36fd                	addiw	a3,a3,-1
    80003554:	02069613          	slli	a2,a3,0x20
    80003558:	01e65693          	srli	a3,a2,0x1e
    8000355c:	00015617          	auipc	a2,0x15
    80003560:	65860613          	addi	a2,a2,1624 # 80018bb4 <log+0x34>
    80003564:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003566:	4390                	lw	a2,0(a5)
    80003568:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000356a:	0791                	addi	a5,a5,4
    8000356c:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000356e:	fed79ce3          	bne	a5,a3,80003566 <write_head+0x50>
  }
  bwrite(buf);
    80003572:	8526                	mv	a0,s1
    80003574:	fffff097          	auipc	ra,0xfffff
    80003578:	096080e7          	jalr	150(ra) # 8000260a <bwrite>
  brelse(buf);
    8000357c:	8526                	mv	a0,s1
    8000357e:	fffff097          	auipc	ra,0xfffff
    80003582:	0ca080e7          	jalr	202(ra) # 80002648 <brelse>
}
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	64a2                	ld	s1,8(sp)
    8000358c:	6902                	ld	s2,0(sp)
    8000358e:	6105                	addi	sp,sp,32
    80003590:	8082                	ret

0000000080003592 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003592:	00015797          	auipc	a5,0x15
    80003596:	61a7a783          	lw	a5,1562(a5) # 80018bac <log+0x2c>
    8000359a:	0af05d63          	blez	a5,80003654 <install_trans+0xc2>
{
    8000359e:	7139                	addi	sp,sp,-64
    800035a0:	fc06                	sd	ra,56(sp)
    800035a2:	f822                	sd	s0,48(sp)
    800035a4:	f426                	sd	s1,40(sp)
    800035a6:	f04a                	sd	s2,32(sp)
    800035a8:	ec4e                	sd	s3,24(sp)
    800035aa:	e852                	sd	s4,16(sp)
    800035ac:	e456                	sd	s5,8(sp)
    800035ae:	e05a                	sd	s6,0(sp)
    800035b0:	0080                	addi	s0,sp,64
    800035b2:	8b2a                	mv	s6,a0
    800035b4:	00015a97          	auipc	s5,0x15
    800035b8:	5fca8a93          	addi	s5,s5,1532 # 80018bb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035bc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035be:	00015997          	auipc	s3,0x15
    800035c2:	5c298993          	addi	s3,s3,1474 # 80018b80 <log>
    800035c6:	a00d                	j	800035e8 <install_trans+0x56>
    brelse(lbuf);
    800035c8:	854a                	mv	a0,s2
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	07e080e7          	jalr	126(ra) # 80002648 <brelse>
    brelse(dbuf);
    800035d2:	8526                	mv	a0,s1
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	074080e7          	jalr	116(ra) # 80002648 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035dc:	2a05                	addiw	s4,s4,1
    800035de:	0a91                	addi	s5,s5,4
    800035e0:	02c9a783          	lw	a5,44(s3)
    800035e4:	04fa5e63          	bge	s4,a5,80003640 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035e8:	0189a583          	lw	a1,24(s3)
    800035ec:	014585bb          	addw	a1,a1,s4
    800035f0:	2585                	addiw	a1,a1,1
    800035f2:	0289a503          	lw	a0,40(s3)
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	f22080e7          	jalr	-222(ra) # 80002518 <bread>
    800035fe:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003600:	000aa583          	lw	a1,0(s5)
    80003604:	0289a503          	lw	a0,40(s3)
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	f10080e7          	jalr	-240(ra) # 80002518 <bread>
    80003610:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003612:	40000613          	li	a2,1024
    80003616:	05890593          	addi	a1,s2,88
    8000361a:	05850513          	addi	a0,a0,88
    8000361e:	ffffd097          	auipc	ra,0xffffd
    80003622:	bb8080e7          	jalr	-1096(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003626:	8526                	mv	a0,s1
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	fe2080e7          	jalr	-30(ra) # 8000260a <bwrite>
    if(recovering == 0)
    80003630:	f80b1ce3          	bnez	s6,800035c8 <install_trans+0x36>
      bunpin(dbuf);
    80003634:	8526                	mv	a0,s1
    80003636:	fffff097          	auipc	ra,0xfffff
    8000363a:	0ec080e7          	jalr	236(ra) # 80002722 <bunpin>
    8000363e:	b769                	j	800035c8 <install_trans+0x36>
}
    80003640:	70e2                	ld	ra,56(sp)
    80003642:	7442                	ld	s0,48(sp)
    80003644:	74a2                	ld	s1,40(sp)
    80003646:	7902                	ld	s2,32(sp)
    80003648:	69e2                	ld	s3,24(sp)
    8000364a:	6a42                	ld	s4,16(sp)
    8000364c:	6aa2                	ld	s5,8(sp)
    8000364e:	6b02                	ld	s6,0(sp)
    80003650:	6121                	addi	sp,sp,64
    80003652:	8082                	ret
    80003654:	8082                	ret

0000000080003656 <initlog>:
{
    80003656:	7179                	addi	sp,sp,-48
    80003658:	f406                	sd	ra,40(sp)
    8000365a:	f022                	sd	s0,32(sp)
    8000365c:	ec26                	sd	s1,24(sp)
    8000365e:	e84a                	sd	s2,16(sp)
    80003660:	e44e                	sd	s3,8(sp)
    80003662:	1800                	addi	s0,sp,48
    80003664:	892a                	mv	s2,a0
    80003666:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003668:	00015497          	auipc	s1,0x15
    8000366c:	51848493          	addi	s1,s1,1304 # 80018b80 <log>
    80003670:	00005597          	auipc	a1,0x5
    80003674:	fe058593          	addi	a1,a1,-32 # 80008650 <syscalls+0x250>
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	c2a080e7          	jalr	-982(ra) # 800062a4 <initlock>
  log.start = sb->logstart;
    80003682:	0149a583          	lw	a1,20(s3)
    80003686:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003688:	0109a783          	lw	a5,16(s3)
    8000368c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000368e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003692:	854a                	mv	a0,s2
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	e84080e7          	jalr	-380(ra) # 80002518 <bread>
  log.lh.n = lh->n;
    8000369c:	4d34                	lw	a3,88(a0)
    8000369e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036a0:	02d05663          	blez	a3,800036cc <initlog+0x76>
    800036a4:	05c50793          	addi	a5,a0,92
    800036a8:	00015717          	auipc	a4,0x15
    800036ac:	50870713          	addi	a4,a4,1288 # 80018bb0 <log+0x30>
    800036b0:	36fd                	addiw	a3,a3,-1
    800036b2:	02069613          	slli	a2,a3,0x20
    800036b6:	01e65693          	srli	a3,a2,0x1e
    800036ba:	06050613          	addi	a2,a0,96
    800036be:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036c0:	4390                	lw	a2,0(a5)
    800036c2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036c4:	0791                	addi	a5,a5,4
    800036c6:	0711                	addi	a4,a4,4
    800036c8:	fed79ce3          	bne	a5,a3,800036c0 <initlog+0x6a>
  brelse(buf);
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	f7c080e7          	jalr	-132(ra) # 80002648 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036d4:	4505                	li	a0,1
    800036d6:	00000097          	auipc	ra,0x0
    800036da:	ebc080e7          	jalr	-324(ra) # 80003592 <install_trans>
  log.lh.n = 0;
    800036de:	00015797          	auipc	a5,0x15
    800036e2:	4c07a723          	sw	zero,1230(a5) # 80018bac <log+0x2c>
  write_head(); // clear the log
    800036e6:	00000097          	auipc	ra,0x0
    800036ea:	e30080e7          	jalr	-464(ra) # 80003516 <write_head>
}
    800036ee:	70a2                	ld	ra,40(sp)
    800036f0:	7402                	ld	s0,32(sp)
    800036f2:	64e2                	ld	s1,24(sp)
    800036f4:	6942                	ld	s2,16(sp)
    800036f6:	69a2                	ld	s3,8(sp)
    800036f8:	6145                	addi	sp,sp,48
    800036fa:	8082                	ret

00000000800036fc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036fc:	1101                	addi	sp,sp,-32
    800036fe:	ec06                	sd	ra,24(sp)
    80003700:	e822                	sd	s0,16(sp)
    80003702:	e426                	sd	s1,8(sp)
    80003704:	e04a                	sd	s2,0(sp)
    80003706:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003708:	00015517          	auipc	a0,0x15
    8000370c:	47850513          	addi	a0,a0,1144 # 80018b80 <log>
    80003710:	00003097          	auipc	ra,0x3
    80003714:	c24080e7          	jalr	-988(ra) # 80006334 <acquire>
  while(1){
    if(log.committing){
    80003718:	00015497          	auipc	s1,0x15
    8000371c:	46848493          	addi	s1,s1,1128 # 80018b80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003720:	4979                	li	s2,30
    80003722:	a039                	j	80003730 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003724:	85a6                	mv	a1,s1
    80003726:	8526                	mv	a0,s1
    80003728:	ffffe097          	auipc	ra,0xffffe
    8000372c:	f40080e7          	jalr	-192(ra) # 80001668 <sleep>
    if(log.committing){
    80003730:	50dc                	lw	a5,36(s1)
    80003732:	fbed                	bnez	a5,80003724 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003734:	5098                	lw	a4,32(s1)
    80003736:	2705                	addiw	a4,a4,1
    80003738:	0007069b          	sext.w	a3,a4
    8000373c:	0027179b          	slliw	a5,a4,0x2
    80003740:	9fb9                	addw	a5,a5,a4
    80003742:	0017979b          	slliw	a5,a5,0x1
    80003746:	54d8                	lw	a4,44(s1)
    80003748:	9fb9                	addw	a5,a5,a4
    8000374a:	00f95963          	bge	s2,a5,8000375c <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000374e:	85a6                	mv	a1,s1
    80003750:	8526                	mv	a0,s1
    80003752:	ffffe097          	auipc	ra,0xffffe
    80003756:	f16080e7          	jalr	-234(ra) # 80001668 <sleep>
    8000375a:	bfd9                	j	80003730 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000375c:	00015517          	auipc	a0,0x15
    80003760:	42450513          	addi	a0,a0,1060 # 80018b80 <log>
    80003764:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	c82080e7          	jalr	-894(ra) # 800063e8 <release>
      break;
    }
  }
}
    8000376e:	60e2                	ld	ra,24(sp)
    80003770:	6442                	ld	s0,16(sp)
    80003772:	64a2                	ld	s1,8(sp)
    80003774:	6902                	ld	s2,0(sp)
    80003776:	6105                	addi	sp,sp,32
    80003778:	8082                	ret

000000008000377a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000377a:	7139                	addi	sp,sp,-64
    8000377c:	fc06                	sd	ra,56(sp)
    8000377e:	f822                	sd	s0,48(sp)
    80003780:	f426                	sd	s1,40(sp)
    80003782:	f04a                	sd	s2,32(sp)
    80003784:	ec4e                	sd	s3,24(sp)
    80003786:	e852                	sd	s4,16(sp)
    80003788:	e456                	sd	s5,8(sp)
    8000378a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000378c:	00015497          	auipc	s1,0x15
    80003790:	3f448493          	addi	s1,s1,1012 # 80018b80 <log>
    80003794:	8526                	mv	a0,s1
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	b9e080e7          	jalr	-1122(ra) # 80006334 <acquire>
  log.outstanding -= 1;
    8000379e:	509c                	lw	a5,32(s1)
    800037a0:	37fd                	addiw	a5,a5,-1
    800037a2:	0007891b          	sext.w	s2,a5
    800037a6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037a8:	50dc                	lw	a5,36(s1)
    800037aa:	e7b9                	bnez	a5,800037f8 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ac:	04091e63          	bnez	s2,80003808 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037b0:	00015497          	auipc	s1,0x15
    800037b4:	3d048493          	addi	s1,s1,976 # 80018b80 <log>
    800037b8:	4785                	li	a5,1
    800037ba:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037bc:	8526                	mv	a0,s1
    800037be:	00003097          	auipc	ra,0x3
    800037c2:	c2a080e7          	jalr	-982(ra) # 800063e8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037c6:	54dc                	lw	a5,44(s1)
    800037c8:	06f04763          	bgtz	a5,80003836 <end_op+0xbc>
    acquire(&log.lock);
    800037cc:	00015497          	auipc	s1,0x15
    800037d0:	3b448493          	addi	s1,s1,948 # 80018b80 <log>
    800037d4:	8526                	mv	a0,s1
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	b5e080e7          	jalr	-1186(ra) # 80006334 <acquire>
    log.committing = 0;
    800037de:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037e2:	8526                	mv	a0,s1
    800037e4:	ffffe097          	auipc	ra,0xffffe
    800037e8:	ee8080e7          	jalr	-280(ra) # 800016cc <wakeup>
    release(&log.lock);
    800037ec:	8526                	mv	a0,s1
    800037ee:	00003097          	auipc	ra,0x3
    800037f2:	bfa080e7          	jalr	-1030(ra) # 800063e8 <release>
}
    800037f6:	a03d                	j	80003824 <end_op+0xaa>
    panic("log.committing");
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	e6050513          	addi	a0,a0,-416 # 80008658 <syscalls+0x258>
    80003800:	00002097          	auipc	ra,0x2
    80003804:	5fc080e7          	jalr	1532(ra) # 80005dfc <panic>
    wakeup(&log);
    80003808:	00015497          	auipc	s1,0x15
    8000380c:	37848493          	addi	s1,s1,888 # 80018b80 <log>
    80003810:	8526                	mv	a0,s1
    80003812:	ffffe097          	auipc	ra,0xffffe
    80003816:	eba080e7          	jalr	-326(ra) # 800016cc <wakeup>
  release(&log.lock);
    8000381a:	8526                	mv	a0,s1
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	bcc080e7          	jalr	-1076(ra) # 800063e8 <release>
}
    80003824:	70e2                	ld	ra,56(sp)
    80003826:	7442                	ld	s0,48(sp)
    80003828:	74a2                	ld	s1,40(sp)
    8000382a:	7902                	ld	s2,32(sp)
    8000382c:	69e2                	ld	s3,24(sp)
    8000382e:	6a42                	ld	s4,16(sp)
    80003830:	6aa2                	ld	s5,8(sp)
    80003832:	6121                	addi	sp,sp,64
    80003834:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003836:	00015a97          	auipc	s5,0x15
    8000383a:	37aa8a93          	addi	s5,s5,890 # 80018bb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000383e:	00015a17          	auipc	s4,0x15
    80003842:	342a0a13          	addi	s4,s4,834 # 80018b80 <log>
    80003846:	018a2583          	lw	a1,24(s4)
    8000384a:	012585bb          	addw	a1,a1,s2
    8000384e:	2585                	addiw	a1,a1,1
    80003850:	028a2503          	lw	a0,40(s4)
    80003854:	fffff097          	auipc	ra,0xfffff
    80003858:	cc4080e7          	jalr	-828(ra) # 80002518 <bread>
    8000385c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000385e:	000aa583          	lw	a1,0(s5)
    80003862:	028a2503          	lw	a0,40(s4)
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	cb2080e7          	jalr	-846(ra) # 80002518 <bread>
    8000386e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003870:	40000613          	li	a2,1024
    80003874:	05850593          	addi	a1,a0,88
    80003878:	05848513          	addi	a0,s1,88
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	95a080e7          	jalr	-1702(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003884:	8526                	mv	a0,s1
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	d84080e7          	jalr	-636(ra) # 8000260a <bwrite>
    brelse(from);
    8000388e:	854e                	mv	a0,s3
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	db8080e7          	jalr	-584(ra) # 80002648 <brelse>
    brelse(to);
    80003898:	8526                	mv	a0,s1
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	dae080e7          	jalr	-594(ra) # 80002648 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a2:	2905                	addiw	s2,s2,1
    800038a4:	0a91                	addi	s5,s5,4
    800038a6:	02ca2783          	lw	a5,44(s4)
    800038aa:	f8f94ee3          	blt	s2,a5,80003846 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	c68080e7          	jalr	-920(ra) # 80003516 <write_head>
    install_trans(0); // Now install writes to home locations
    800038b6:	4501                	li	a0,0
    800038b8:	00000097          	auipc	ra,0x0
    800038bc:	cda080e7          	jalr	-806(ra) # 80003592 <install_trans>
    log.lh.n = 0;
    800038c0:	00015797          	auipc	a5,0x15
    800038c4:	2e07a623          	sw	zero,748(a5) # 80018bac <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038c8:	00000097          	auipc	ra,0x0
    800038cc:	c4e080e7          	jalr	-946(ra) # 80003516 <write_head>
    800038d0:	bdf5                	j	800037cc <end_op+0x52>

00000000800038d2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038d2:	1101                	addi	sp,sp,-32
    800038d4:	ec06                	sd	ra,24(sp)
    800038d6:	e822                	sd	s0,16(sp)
    800038d8:	e426                	sd	s1,8(sp)
    800038da:	e04a                	sd	s2,0(sp)
    800038dc:	1000                	addi	s0,sp,32
    800038de:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038e0:	00015917          	auipc	s2,0x15
    800038e4:	2a090913          	addi	s2,s2,672 # 80018b80 <log>
    800038e8:	854a                	mv	a0,s2
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	a4a080e7          	jalr	-1462(ra) # 80006334 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038f2:	02c92603          	lw	a2,44(s2)
    800038f6:	47f5                	li	a5,29
    800038f8:	06c7c563          	blt	a5,a2,80003962 <log_write+0x90>
    800038fc:	00015797          	auipc	a5,0x15
    80003900:	2a07a783          	lw	a5,672(a5) # 80018b9c <log+0x1c>
    80003904:	37fd                	addiw	a5,a5,-1
    80003906:	04f65e63          	bge	a2,a5,80003962 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000390a:	00015797          	auipc	a5,0x15
    8000390e:	2967a783          	lw	a5,662(a5) # 80018ba0 <log+0x20>
    80003912:	06f05063          	blez	a5,80003972 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003916:	4781                	li	a5,0
    80003918:	06c05563          	blez	a2,80003982 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000391c:	44cc                	lw	a1,12(s1)
    8000391e:	00015717          	auipc	a4,0x15
    80003922:	29270713          	addi	a4,a4,658 # 80018bb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003926:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003928:	4314                	lw	a3,0(a4)
    8000392a:	04b68c63          	beq	a3,a1,80003982 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000392e:	2785                	addiw	a5,a5,1
    80003930:	0711                	addi	a4,a4,4
    80003932:	fef61be3          	bne	a2,a5,80003928 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003936:	0621                	addi	a2,a2,8
    80003938:	060a                	slli	a2,a2,0x2
    8000393a:	00015797          	auipc	a5,0x15
    8000393e:	24678793          	addi	a5,a5,582 # 80018b80 <log>
    80003942:	97b2                	add	a5,a5,a2
    80003944:	44d8                	lw	a4,12(s1)
    80003946:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003948:	8526                	mv	a0,s1
    8000394a:	fffff097          	auipc	ra,0xfffff
    8000394e:	d9c080e7          	jalr	-612(ra) # 800026e6 <bpin>
    log.lh.n++;
    80003952:	00015717          	auipc	a4,0x15
    80003956:	22e70713          	addi	a4,a4,558 # 80018b80 <log>
    8000395a:	575c                	lw	a5,44(a4)
    8000395c:	2785                	addiw	a5,a5,1
    8000395e:	d75c                	sw	a5,44(a4)
    80003960:	a82d                	j	8000399a <log_write+0xc8>
    panic("too big a transaction");
    80003962:	00005517          	auipc	a0,0x5
    80003966:	d0650513          	addi	a0,a0,-762 # 80008668 <syscalls+0x268>
    8000396a:	00002097          	auipc	ra,0x2
    8000396e:	492080e7          	jalr	1170(ra) # 80005dfc <panic>
    panic("log_write outside of trans");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	d0e50513          	addi	a0,a0,-754 # 80008680 <syscalls+0x280>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	482080e7          	jalr	1154(ra) # 80005dfc <panic>
  log.lh.block[i] = b->blockno;
    80003982:	00878693          	addi	a3,a5,8
    80003986:	068a                	slli	a3,a3,0x2
    80003988:	00015717          	auipc	a4,0x15
    8000398c:	1f870713          	addi	a4,a4,504 # 80018b80 <log>
    80003990:	9736                	add	a4,a4,a3
    80003992:	44d4                	lw	a3,12(s1)
    80003994:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003996:	faf609e3          	beq	a2,a5,80003948 <log_write+0x76>
  }
  release(&log.lock);
    8000399a:	00015517          	auipc	a0,0x15
    8000399e:	1e650513          	addi	a0,a0,486 # 80018b80 <log>
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	a46080e7          	jalr	-1466(ra) # 800063e8 <release>
}
    800039aa:	60e2                	ld	ra,24(sp)
    800039ac:	6442                	ld	s0,16(sp)
    800039ae:	64a2                	ld	s1,8(sp)
    800039b0:	6902                	ld	s2,0(sp)
    800039b2:	6105                	addi	sp,sp,32
    800039b4:	8082                	ret

00000000800039b6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	e04a                	sd	s2,0(sp)
    800039c0:	1000                	addi	s0,sp,32
    800039c2:	84aa                	mv	s1,a0
    800039c4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039c6:	00005597          	auipc	a1,0x5
    800039ca:	cda58593          	addi	a1,a1,-806 # 800086a0 <syscalls+0x2a0>
    800039ce:	0521                	addi	a0,a0,8
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	8d4080e7          	jalr	-1836(ra) # 800062a4 <initlock>
  lk->name = name;
    800039d8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039dc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039e0:	0204a423          	sw	zero,40(s1)
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	e04a                	sd	s2,0(sp)
    800039fa:	1000                	addi	s0,sp,32
    800039fc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039fe:	00850913          	addi	s2,a0,8
    80003a02:	854a                	mv	a0,s2
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	930080e7          	jalr	-1744(ra) # 80006334 <acquire>
  while (lk->locked) {
    80003a0c:	409c                	lw	a5,0(s1)
    80003a0e:	cb89                	beqz	a5,80003a20 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a10:	85ca                	mv	a1,s2
    80003a12:	8526                	mv	a0,s1
    80003a14:	ffffe097          	auipc	ra,0xffffe
    80003a18:	c54080e7          	jalr	-940(ra) # 80001668 <sleep>
  while (lk->locked) {
    80003a1c:	409c                	lw	a5,0(s1)
    80003a1e:	fbed                	bnez	a5,80003a10 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a20:	4785                	li	a5,1
    80003a22:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a24:	ffffd097          	auipc	ra,0xffffd
    80003a28:	51a080e7          	jalr	1306(ra) # 80000f3e <myproc>
    80003a2c:	591c                	lw	a5,48(a0)
    80003a2e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a30:	854a                	mv	a0,s2
    80003a32:	00003097          	auipc	ra,0x3
    80003a36:	9b6080e7          	jalr	-1610(ra) # 800063e8 <release>
}
    80003a3a:	60e2                	ld	ra,24(sp)
    80003a3c:	6442                	ld	s0,16(sp)
    80003a3e:	64a2                	ld	s1,8(sp)
    80003a40:	6902                	ld	s2,0(sp)
    80003a42:	6105                	addi	sp,sp,32
    80003a44:	8082                	ret

0000000080003a46 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a46:	1101                	addi	sp,sp,-32
    80003a48:	ec06                	sd	ra,24(sp)
    80003a4a:	e822                	sd	s0,16(sp)
    80003a4c:	e426                	sd	s1,8(sp)
    80003a4e:	e04a                	sd	s2,0(sp)
    80003a50:	1000                	addi	s0,sp,32
    80003a52:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a54:	00850913          	addi	s2,a0,8
    80003a58:	854a                	mv	a0,s2
    80003a5a:	00003097          	auipc	ra,0x3
    80003a5e:	8da080e7          	jalr	-1830(ra) # 80006334 <acquire>
  lk->locked = 0;
    80003a62:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a66:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	ffffe097          	auipc	ra,0xffffe
    80003a70:	c60080e7          	jalr	-928(ra) # 800016cc <wakeup>
  release(&lk->lk);
    80003a74:	854a                	mv	a0,s2
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	972080e7          	jalr	-1678(ra) # 800063e8 <release>
}
    80003a7e:	60e2                	ld	ra,24(sp)
    80003a80:	6442                	ld	s0,16(sp)
    80003a82:	64a2                	ld	s1,8(sp)
    80003a84:	6902                	ld	s2,0(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret

0000000080003a8a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a8a:	7179                	addi	sp,sp,-48
    80003a8c:	f406                	sd	ra,40(sp)
    80003a8e:	f022                	sd	s0,32(sp)
    80003a90:	ec26                	sd	s1,24(sp)
    80003a92:	e84a                	sd	s2,16(sp)
    80003a94:	e44e                	sd	s3,8(sp)
    80003a96:	1800                	addi	s0,sp,48
    80003a98:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a9a:	00850913          	addi	s2,a0,8
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	00003097          	auipc	ra,0x3
    80003aa4:	894080e7          	jalr	-1900(ra) # 80006334 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa8:	409c                	lw	a5,0(s1)
    80003aaa:	ef99                	bnez	a5,80003ac8 <holdingsleep+0x3e>
    80003aac:	4481                	li	s1,0
  release(&lk->lk);
    80003aae:	854a                	mv	a0,s2
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	938080e7          	jalr	-1736(ra) # 800063e8 <release>
  return r;
}
    80003ab8:	8526                	mv	a0,s1
    80003aba:	70a2                	ld	ra,40(sp)
    80003abc:	7402                	ld	s0,32(sp)
    80003abe:	64e2                	ld	s1,24(sp)
    80003ac0:	6942                	ld	s2,16(sp)
    80003ac2:	69a2                	ld	s3,8(sp)
    80003ac4:	6145                	addi	sp,sp,48
    80003ac6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ac8:	0284a983          	lw	s3,40(s1)
    80003acc:	ffffd097          	auipc	ra,0xffffd
    80003ad0:	472080e7          	jalr	1138(ra) # 80000f3e <myproc>
    80003ad4:	5904                	lw	s1,48(a0)
    80003ad6:	413484b3          	sub	s1,s1,s3
    80003ada:	0014b493          	seqz	s1,s1
    80003ade:	bfc1                	j	80003aae <holdingsleep+0x24>

0000000080003ae0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ae0:	1141                	addi	sp,sp,-16
    80003ae2:	e406                	sd	ra,8(sp)
    80003ae4:	e022                	sd	s0,0(sp)
    80003ae6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ae8:	00005597          	auipc	a1,0x5
    80003aec:	bc858593          	addi	a1,a1,-1080 # 800086b0 <syscalls+0x2b0>
    80003af0:	00015517          	auipc	a0,0x15
    80003af4:	1d850513          	addi	a0,a0,472 # 80018cc8 <ftable>
    80003af8:	00002097          	auipc	ra,0x2
    80003afc:	7ac080e7          	jalr	1964(ra) # 800062a4 <initlock>
}
    80003b00:	60a2                	ld	ra,8(sp)
    80003b02:	6402                	ld	s0,0(sp)
    80003b04:	0141                	addi	sp,sp,16
    80003b06:	8082                	ret

0000000080003b08 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b08:	1101                	addi	sp,sp,-32
    80003b0a:	ec06                	sd	ra,24(sp)
    80003b0c:	e822                	sd	s0,16(sp)
    80003b0e:	e426                	sd	s1,8(sp)
    80003b10:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b12:	00015517          	auipc	a0,0x15
    80003b16:	1b650513          	addi	a0,a0,438 # 80018cc8 <ftable>
    80003b1a:	00003097          	auipc	ra,0x3
    80003b1e:	81a080e7          	jalr	-2022(ra) # 80006334 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b22:	00015497          	auipc	s1,0x15
    80003b26:	1be48493          	addi	s1,s1,446 # 80018ce0 <ftable+0x18>
    80003b2a:	00016717          	auipc	a4,0x16
    80003b2e:	15670713          	addi	a4,a4,342 # 80019c80 <disk>
    if(f->ref == 0){
    80003b32:	40dc                	lw	a5,4(s1)
    80003b34:	cf99                	beqz	a5,80003b52 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b36:	02848493          	addi	s1,s1,40
    80003b3a:	fee49ce3          	bne	s1,a4,80003b32 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b3e:	00015517          	auipc	a0,0x15
    80003b42:	18a50513          	addi	a0,a0,394 # 80018cc8 <ftable>
    80003b46:	00003097          	auipc	ra,0x3
    80003b4a:	8a2080e7          	jalr	-1886(ra) # 800063e8 <release>
  return 0;
    80003b4e:	4481                	li	s1,0
    80003b50:	a819                	j	80003b66 <filealloc+0x5e>
      f->ref = 1;
    80003b52:	4785                	li	a5,1
    80003b54:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b56:	00015517          	auipc	a0,0x15
    80003b5a:	17250513          	addi	a0,a0,370 # 80018cc8 <ftable>
    80003b5e:	00003097          	auipc	ra,0x3
    80003b62:	88a080e7          	jalr	-1910(ra) # 800063e8 <release>
}
    80003b66:	8526                	mv	a0,s1
    80003b68:	60e2                	ld	ra,24(sp)
    80003b6a:	6442                	ld	s0,16(sp)
    80003b6c:	64a2                	ld	s1,8(sp)
    80003b6e:	6105                	addi	sp,sp,32
    80003b70:	8082                	ret

0000000080003b72 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b72:	1101                	addi	sp,sp,-32
    80003b74:	ec06                	sd	ra,24(sp)
    80003b76:	e822                	sd	s0,16(sp)
    80003b78:	e426                	sd	s1,8(sp)
    80003b7a:	1000                	addi	s0,sp,32
    80003b7c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b7e:	00015517          	auipc	a0,0x15
    80003b82:	14a50513          	addi	a0,a0,330 # 80018cc8 <ftable>
    80003b86:	00002097          	auipc	ra,0x2
    80003b8a:	7ae080e7          	jalr	1966(ra) # 80006334 <acquire>
  if(f->ref < 1)
    80003b8e:	40dc                	lw	a5,4(s1)
    80003b90:	02f05263          	blez	a5,80003bb4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b94:	2785                	addiw	a5,a5,1
    80003b96:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b98:	00015517          	auipc	a0,0x15
    80003b9c:	13050513          	addi	a0,a0,304 # 80018cc8 <ftable>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	848080e7          	jalr	-1976(ra) # 800063e8 <release>
  return f;
}
    80003ba8:	8526                	mv	a0,s1
    80003baa:	60e2                	ld	ra,24(sp)
    80003bac:	6442                	ld	s0,16(sp)
    80003bae:	64a2                	ld	s1,8(sp)
    80003bb0:	6105                	addi	sp,sp,32
    80003bb2:	8082                	ret
    panic("filedup");
    80003bb4:	00005517          	auipc	a0,0x5
    80003bb8:	b0450513          	addi	a0,a0,-1276 # 800086b8 <syscalls+0x2b8>
    80003bbc:	00002097          	auipc	ra,0x2
    80003bc0:	240080e7          	jalr	576(ra) # 80005dfc <panic>

0000000080003bc4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bc4:	7139                	addi	sp,sp,-64
    80003bc6:	fc06                	sd	ra,56(sp)
    80003bc8:	f822                	sd	s0,48(sp)
    80003bca:	f426                	sd	s1,40(sp)
    80003bcc:	f04a                	sd	s2,32(sp)
    80003bce:	ec4e                	sd	s3,24(sp)
    80003bd0:	e852                	sd	s4,16(sp)
    80003bd2:	e456                	sd	s5,8(sp)
    80003bd4:	0080                	addi	s0,sp,64
    80003bd6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bd8:	00015517          	auipc	a0,0x15
    80003bdc:	0f050513          	addi	a0,a0,240 # 80018cc8 <ftable>
    80003be0:	00002097          	auipc	ra,0x2
    80003be4:	754080e7          	jalr	1876(ra) # 80006334 <acquire>
  if(f->ref < 1)
    80003be8:	40dc                	lw	a5,4(s1)
    80003bea:	06f05163          	blez	a5,80003c4c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bee:	37fd                	addiw	a5,a5,-1
    80003bf0:	0007871b          	sext.w	a4,a5
    80003bf4:	c0dc                	sw	a5,4(s1)
    80003bf6:	06e04363          	bgtz	a4,80003c5c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bfa:	0004a903          	lw	s2,0(s1)
    80003bfe:	0094ca83          	lbu	s5,9(s1)
    80003c02:	0104ba03          	ld	s4,16(s1)
    80003c06:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c0a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c0e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c12:	00015517          	auipc	a0,0x15
    80003c16:	0b650513          	addi	a0,a0,182 # 80018cc8 <ftable>
    80003c1a:	00002097          	auipc	ra,0x2
    80003c1e:	7ce080e7          	jalr	1998(ra) # 800063e8 <release>

  if(ff.type == FD_PIPE){
    80003c22:	4785                	li	a5,1
    80003c24:	04f90d63          	beq	s2,a5,80003c7e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c28:	3979                	addiw	s2,s2,-2
    80003c2a:	4785                	li	a5,1
    80003c2c:	0527e063          	bltu	a5,s2,80003c6c <fileclose+0xa8>
    begin_op();
    80003c30:	00000097          	auipc	ra,0x0
    80003c34:	acc080e7          	jalr	-1332(ra) # 800036fc <begin_op>
    iput(ff.ip);
    80003c38:	854e                	mv	a0,s3
    80003c3a:	fffff097          	auipc	ra,0xfffff
    80003c3e:	2b0080e7          	jalr	688(ra) # 80002eea <iput>
    end_op();
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	b38080e7          	jalr	-1224(ra) # 8000377a <end_op>
    80003c4a:	a00d                	j	80003c6c <fileclose+0xa8>
    panic("fileclose");
    80003c4c:	00005517          	auipc	a0,0x5
    80003c50:	a7450513          	addi	a0,a0,-1420 # 800086c0 <syscalls+0x2c0>
    80003c54:	00002097          	auipc	ra,0x2
    80003c58:	1a8080e7          	jalr	424(ra) # 80005dfc <panic>
    release(&ftable.lock);
    80003c5c:	00015517          	auipc	a0,0x15
    80003c60:	06c50513          	addi	a0,a0,108 # 80018cc8 <ftable>
    80003c64:	00002097          	auipc	ra,0x2
    80003c68:	784080e7          	jalr	1924(ra) # 800063e8 <release>
  }
}
    80003c6c:	70e2                	ld	ra,56(sp)
    80003c6e:	7442                	ld	s0,48(sp)
    80003c70:	74a2                	ld	s1,40(sp)
    80003c72:	7902                	ld	s2,32(sp)
    80003c74:	69e2                	ld	s3,24(sp)
    80003c76:	6a42                	ld	s4,16(sp)
    80003c78:	6aa2                	ld	s5,8(sp)
    80003c7a:	6121                	addi	sp,sp,64
    80003c7c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c7e:	85d6                	mv	a1,s5
    80003c80:	8552                	mv	a0,s4
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	34c080e7          	jalr	844(ra) # 80003fce <pipeclose>
    80003c8a:	b7cd                	j	80003c6c <fileclose+0xa8>

0000000080003c8c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c8c:	715d                	addi	sp,sp,-80
    80003c8e:	e486                	sd	ra,72(sp)
    80003c90:	e0a2                	sd	s0,64(sp)
    80003c92:	fc26                	sd	s1,56(sp)
    80003c94:	f84a                	sd	s2,48(sp)
    80003c96:	f44e                	sd	s3,40(sp)
    80003c98:	0880                	addi	s0,sp,80
    80003c9a:	84aa                	mv	s1,a0
    80003c9c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c9e:	ffffd097          	auipc	ra,0xffffd
    80003ca2:	2a0080e7          	jalr	672(ra) # 80000f3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ca6:	409c                	lw	a5,0(s1)
    80003ca8:	37f9                	addiw	a5,a5,-2
    80003caa:	4705                	li	a4,1
    80003cac:	04f76763          	bltu	a4,a5,80003cfa <filestat+0x6e>
    80003cb0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cb2:	6c88                	ld	a0,24(s1)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	07c080e7          	jalr	124(ra) # 80002d30 <ilock>
    stati(f->ip, &st);
    80003cbc:	fb840593          	addi	a1,s0,-72
    80003cc0:	6c88                	ld	a0,24(s1)
    80003cc2:	fffff097          	auipc	ra,0xfffff
    80003cc6:	2f8080e7          	jalr	760(ra) # 80002fba <stati>
    iunlock(f->ip);
    80003cca:	6c88                	ld	a0,24(s1)
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	126080e7          	jalr	294(ra) # 80002df2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cd4:	46e1                	li	a3,24
    80003cd6:	fb840613          	addi	a2,s0,-72
    80003cda:	85ce                	mv	a1,s3
    80003cdc:	05093503          	ld	a0,80(s2)
    80003ce0:	ffffd097          	auipc	ra,0xffffd
    80003ce4:	e34080e7          	jalr	-460(ra) # 80000b14 <copyout>
    80003ce8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cec:	60a6                	ld	ra,72(sp)
    80003cee:	6406                	ld	s0,64(sp)
    80003cf0:	74e2                	ld	s1,56(sp)
    80003cf2:	7942                	ld	s2,48(sp)
    80003cf4:	79a2                	ld	s3,40(sp)
    80003cf6:	6161                	addi	sp,sp,80
    80003cf8:	8082                	ret
  return -1;
    80003cfa:	557d                	li	a0,-1
    80003cfc:	bfc5                	j	80003cec <filestat+0x60>

0000000080003cfe <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cfe:	7179                	addi	sp,sp,-48
    80003d00:	f406                	sd	ra,40(sp)
    80003d02:	f022                	sd	s0,32(sp)
    80003d04:	ec26                	sd	s1,24(sp)
    80003d06:	e84a                	sd	s2,16(sp)
    80003d08:	e44e                	sd	s3,8(sp)
    80003d0a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d0c:	00854783          	lbu	a5,8(a0)
    80003d10:	c3d5                	beqz	a5,80003db4 <fileread+0xb6>
    80003d12:	84aa                	mv	s1,a0
    80003d14:	89ae                	mv	s3,a1
    80003d16:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d18:	411c                	lw	a5,0(a0)
    80003d1a:	4705                	li	a4,1
    80003d1c:	04e78963          	beq	a5,a4,80003d6e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d20:	470d                	li	a4,3
    80003d22:	04e78d63          	beq	a5,a4,80003d7c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d26:	4709                	li	a4,2
    80003d28:	06e79e63          	bne	a5,a4,80003da4 <fileread+0xa6>
    ilock(f->ip);
    80003d2c:	6d08                	ld	a0,24(a0)
    80003d2e:	fffff097          	auipc	ra,0xfffff
    80003d32:	002080e7          	jalr	2(ra) # 80002d30 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d36:	874a                	mv	a4,s2
    80003d38:	5094                	lw	a3,32(s1)
    80003d3a:	864e                	mv	a2,s3
    80003d3c:	4585                	li	a1,1
    80003d3e:	6c88                	ld	a0,24(s1)
    80003d40:	fffff097          	auipc	ra,0xfffff
    80003d44:	2a4080e7          	jalr	676(ra) # 80002fe4 <readi>
    80003d48:	892a                	mv	s2,a0
    80003d4a:	00a05563          	blez	a0,80003d54 <fileread+0x56>
      f->off += r;
    80003d4e:	509c                	lw	a5,32(s1)
    80003d50:	9fa9                	addw	a5,a5,a0
    80003d52:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d54:	6c88                	ld	a0,24(s1)
    80003d56:	fffff097          	auipc	ra,0xfffff
    80003d5a:	09c080e7          	jalr	156(ra) # 80002df2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d5e:	854a                	mv	a0,s2
    80003d60:	70a2                	ld	ra,40(sp)
    80003d62:	7402                	ld	s0,32(sp)
    80003d64:	64e2                	ld	s1,24(sp)
    80003d66:	6942                	ld	s2,16(sp)
    80003d68:	69a2                	ld	s3,8(sp)
    80003d6a:	6145                	addi	sp,sp,48
    80003d6c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d6e:	6908                	ld	a0,16(a0)
    80003d70:	00000097          	auipc	ra,0x0
    80003d74:	3c6080e7          	jalr	966(ra) # 80004136 <piperead>
    80003d78:	892a                	mv	s2,a0
    80003d7a:	b7d5                	j	80003d5e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d7c:	02451783          	lh	a5,36(a0)
    80003d80:	03079693          	slli	a3,a5,0x30
    80003d84:	92c1                	srli	a3,a3,0x30
    80003d86:	4725                	li	a4,9
    80003d88:	02d76863          	bltu	a4,a3,80003db8 <fileread+0xba>
    80003d8c:	0792                	slli	a5,a5,0x4
    80003d8e:	00015717          	auipc	a4,0x15
    80003d92:	e9a70713          	addi	a4,a4,-358 # 80018c28 <devsw>
    80003d96:	97ba                	add	a5,a5,a4
    80003d98:	639c                	ld	a5,0(a5)
    80003d9a:	c38d                	beqz	a5,80003dbc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d9c:	4505                	li	a0,1
    80003d9e:	9782                	jalr	a5
    80003da0:	892a                	mv	s2,a0
    80003da2:	bf75                	j	80003d5e <fileread+0x60>
    panic("fileread");
    80003da4:	00005517          	auipc	a0,0x5
    80003da8:	92c50513          	addi	a0,a0,-1748 # 800086d0 <syscalls+0x2d0>
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	050080e7          	jalr	80(ra) # 80005dfc <panic>
    return -1;
    80003db4:	597d                	li	s2,-1
    80003db6:	b765                	j	80003d5e <fileread+0x60>
      return -1;
    80003db8:	597d                	li	s2,-1
    80003dba:	b755                	j	80003d5e <fileread+0x60>
    80003dbc:	597d                	li	s2,-1
    80003dbe:	b745                	j	80003d5e <fileread+0x60>

0000000080003dc0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dc0:	715d                	addi	sp,sp,-80
    80003dc2:	e486                	sd	ra,72(sp)
    80003dc4:	e0a2                	sd	s0,64(sp)
    80003dc6:	fc26                	sd	s1,56(sp)
    80003dc8:	f84a                	sd	s2,48(sp)
    80003dca:	f44e                	sd	s3,40(sp)
    80003dcc:	f052                	sd	s4,32(sp)
    80003dce:	ec56                	sd	s5,24(sp)
    80003dd0:	e85a                	sd	s6,16(sp)
    80003dd2:	e45e                	sd	s7,8(sp)
    80003dd4:	e062                	sd	s8,0(sp)
    80003dd6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dd8:	00954783          	lbu	a5,9(a0)
    80003ddc:	10078663          	beqz	a5,80003ee8 <filewrite+0x128>
    80003de0:	892a                	mv	s2,a0
    80003de2:	8b2e                	mv	s6,a1
    80003de4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de6:	411c                	lw	a5,0(a0)
    80003de8:	4705                	li	a4,1
    80003dea:	02e78263          	beq	a5,a4,80003e0e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dee:	470d                	li	a4,3
    80003df0:	02e78663          	beq	a5,a4,80003e1c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df4:	4709                	li	a4,2
    80003df6:	0ee79163          	bne	a5,a4,80003ed8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dfa:	0ac05d63          	blez	a2,80003eb4 <filewrite+0xf4>
    int i = 0;
    80003dfe:	4981                	li	s3,0
    80003e00:	6b85                	lui	s7,0x1
    80003e02:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e06:	6c05                	lui	s8,0x1
    80003e08:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e0c:	a861                	j	80003ea4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e0e:	6908                	ld	a0,16(a0)
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	22e080e7          	jalr	558(ra) # 8000403e <pipewrite>
    80003e18:	8a2a                	mv	s4,a0
    80003e1a:	a045                	j	80003eba <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e1c:	02451783          	lh	a5,36(a0)
    80003e20:	03079693          	slli	a3,a5,0x30
    80003e24:	92c1                	srli	a3,a3,0x30
    80003e26:	4725                	li	a4,9
    80003e28:	0cd76263          	bltu	a4,a3,80003eec <filewrite+0x12c>
    80003e2c:	0792                	slli	a5,a5,0x4
    80003e2e:	00015717          	auipc	a4,0x15
    80003e32:	dfa70713          	addi	a4,a4,-518 # 80018c28 <devsw>
    80003e36:	97ba                	add	a5,a5,a4
    80003e38:	679c                	ld	a5,8(a5)
    80003e3a:	cbdd                	beqz	a5,80003ef0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e3c:	4505                	li	a0,1
    80003e3e:	9782                	jalr	a5
    80003e40:	8a2a                	mv	s4,a0
    80003e42:	a8a5                	j	80003eba <filewrite+0xfa>
    80003e44:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	8b4080e7          	jalr	-1868(ra) # 800036fc <begin_op>
      ilock(f->ip);
    80003e50:	01893503          	ld	a0,24(s2)
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	edc080e7          	jalr	-292(ra) # 80002d30 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e5c:	8756                	mv	a4,s5
    80003e5e:	02092683          	lw	a3,32(s2)
    80003e62:	01698633          	add	a2,s3,s6
    80003e66:	4585                	li	a1,1
    80003e68:	01893503          	ld	a0,24(s2)
    80003e6c:	fffff097          	auipc	ra,0xfffff
    80003e70:	270080e7          	jalr	624(ra) # 800030dc <writei>
    80003e74:	84aa                	mv	s1,a0
    80003e76:	00a05763          	blez	a0,80003e84 <filewrite+0xc4>
        f->off += r;
    80003e7a:	02092783          	lw	a5,32(s2)
    80003e7e:	9fa9                	addw	a5,a5,a0
    80003e80:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e84:	01893503          	ld	a0,24(s2)
    80003e88:	fffff097          	auipc	ra,0xfffff
    80003e8c:	f6a080e7          	jalr	-150(ra) # 80002df2 <iunlock>
      end_op();
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	8ea080e7          	jalr	-1814(ra) # 8000377a <end_op>

      if(r != n1){
    80003e98:	009a9f63          	bne	s5,s1,80003eb6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e9c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ea0:	0149db63          	bge	s3,s4,80003eb6 <filewrite+0xf6>
      int n1 = n - i;
    80003ea4:	413a04bb          	subw	s1,s4,s3
    80003ea8:	0004879b          	sext.w	a5,s1
    80003eac:	f8fbdce3          	bge	s7,a5,80003e44 <filewrite+0x84>
    80003eb0:	84e2                	mv	s1,s8
    80003eb2:	bf49                	j	80003e44 <filewrite+0x84>
    int i = 0;
    80003eb4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003eb6:	013a1f63          	bne	s4,s3,80003ed4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eba:	8552                	mv	a0,s4
    80003ebc:	60a6                	ld	ra,72(sp)
    80003ebe:	6406                	ld	s0,64(sp)
    80003ec0:	74e2                	ld	s1,56(sp)
    80003ec2:	7942                	ld	s2,48(sp)
    80003ec4:	79a2                	ld	s3,40(sp)
    80003ec6:	7a02                	ld	s4,32(sp)
    80003ec8:	6ae2                	ld	s5,24(sp)
    80003eca:	6b42                	ld	s6,16(sp)
    80003ecc:	6ba2                	ld	s7,8(sp)
    80003ece:	6c02                	ld	s8,0(sp)
    80003ed0:	6161                	addi	sp,sp,80
    80003ed2:	8082                	ret
    ret = (i == n ? n : -1);
    80003ed4:	5a7d                	li	s4,-1
    80003ed6:	b7d5                	j	80003eba <filewrite+0xfa>
    panic("filewrite");
    80003ed8:	00005517          	auipc	a0,0x5
    80003edc:	80850513          	addi	a0,a0,-2040 # 800086e0 <syscalls+0x2e0>
    80003ee0:	00002097          	auipc	ra,0x2
    80003ee4:	f1c080e7          	jalr	-228(ra) # 80005dfc <panic>
    return -1;
    80003ee8:	5a7d                	li	s4,-1
    80003eea:	bfc1                	j	80003eba <filewrite+0xfa>
      return -1;
    80003eec:	5a7d                	li	s4,-1
    80003eee:	b7f1                	j	80003eba <filewrite+0xfa>
    80003ef0:	5a7d                	li	s4,-1
    80003ef2:	b7e1                	j	80003eba <filewrite+0xfa>

0000000080003ef4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ef4:	7179                	addi	sp,sp,-48
    80003ef6:	f406                	sd	ra,40(sp)
    80003ef8:	f022                	sd	s0,32(sp)
    80003efa:	ec26                	sd	s1,24(sp)
    80003efc:	e84a                	sd	s2,16(sp)
    80003efe:	e44e                	sd	s3,8(sp)
    80003f00:	e052                	sd	s4,0(sp)
    80003f02:	1800                	addi	s0,sp,48
    80003f04:	84aa                	mv	s1,a0
    80003f06:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f08:	0005b023          	sd	zero,0(a1)
    80003f0c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	bf8080e7          	jalr	-1032(ra) # 80003b08 <filealloc>
    80003f18:	e088                	sd	a0,0(s1)
    80003f1a:	c551                	beqz	a0,80003fa6 <pipealloc+0xb2>
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	bec080e7          	jalr	-1044(ra) # 80003b08 <filealloc>
    80003f24:	00aa3023          	sd	a0,0(s4)
    80003f28:	c92d                	beqz	a0,80003f9a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f2a:	ffffc097          	auipc	ra,0xffffc
    80003f2e:	1f0080e7          	jalr	496(ra) # 8000011a <kalloc>
    80003f32:	892a                	mv	s2,a0
    80003f34:	c125                	beqz	a0,80003f94 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f36:	4985                	li	s3,1
    80003f38:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f3c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f40:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f44:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f48:	00004597          	auipc	a1,0x4
    80003f4c:	7a858593          	addi	a1,a1,1960 # 800086f0 <syscalls+0x2f0>
    80003f50:	00002097          	auipc	ra,0x2
    80003f54:	354080e7          	jalr	852(ra) # 800062a4 <initlock>
  (*f0)->type = FD_PIPE;
    80003f58:	609c                	ld	a5,0(s1)
    80003f5a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f5e:	609c                	ld	a5,0(s1)
    80003f60:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f64:	609c                	ld	a5,0(s1)
    80003f66:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f6a:	609c                	ld	a5,0(s1)
    80003f6c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f70:	000a3783          	ld	a5,0(s4)
    80003f74:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f78:	000a3783          	ld	a5,0(s4)
    80003f7c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f80:	000a3783          	ld	a5,0(s4)
    80003f84:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f88:	000a3783          	ld	a5,0(s4)
    80003f8c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f90:	4501                	li	a0,0
    80003f92:	a025                	j	80003fba <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f94:	6088                	ld	a0,0(s1)
    80003f96:	e501                	bnez	a0,80003f9e <pipealloc+0xaa>
    80003f98:	a039                	j	80003fa6 <pipealloc+0xb2>
    80003f9a:	6088                	ld	a0,0(s1)
    80003f9c:	c51d                	beqz	a0,80003fca <pipealloc+0xd6>
    fileclose(*f0);
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	c26080e7          	jalr	-986(ra) # 80003bc4 <fileclose>
  if(*f1)
    80003fa6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003faa:	557d                	li	a0,-1
  if(*f1)
    80003fac:	c799                	beqz	a5,80003fba <pipealloc+0xc6>
    fileclose(*f1);
    80003fae:	853e                	mv	a0,a5
    80003fb0:	00000097          	auipc	ra,0x0
    80003fb4:	c14080e7          	jalr	-1004(ra) # 80003bc4 <fileclose>
  return -1;
    80003fb8:	557d                	li	a0,-1
}
    80003fba:	70a2                	ld	ra,40(sp)
    80003fbc:	7402                	ld	s0,32(sp)
    80003fbe:	64e2                	ld	s1,24(sp)
    80003fc0:	6942                	ld	s2,16(sp)
    80003fc2:	69a2                	ld	s3,8(sp)
    80003fc4:	6a02                	ld	s4,0(sp)
    80003fc6:	6145                	addi	sp,sp,48
    80003fc8:	8082                	ret
  return -1;
    80003fca:	557d                	li	a0,-1
    80003fcc:	b7fd                	j	80003fba <pipealloc+0xc6>

0000000080003fce <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fce:	1101                	addi	sp,sp,-32
    80003fd0:	ec06                	sd	ra,24(sp)
    80003fd2:	e822                	sd	s0,16(sp)
    80003fd4:	e426                	sd	s1,8(sp)
    80003fd6:	e04a                	sd	s2,0(sp)
    80003fd8:	1000                	addi	s0,sp,32
    80003fda:	84aa                	mv	s1,a0
    80003fdc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fde:	00002097          	auipc	ra,0x2
    80003fe2:	356080e7          	jalr	854(ra) # 80006334 <acquire>
  if(writable){
    80003fe6:	02090d63          	beqz	s2,80004020 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fea:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fee:	21848513          	addi	a0,s1,536
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	6da080e7          	jalr	1754(ra) # 800016cc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ffa:	2204b783          	ld	a5,544(s1)
    80003ffe:	eb95                	bnez	a5,80004032 <pipeclose+0x64>
    release(&pi->lock);
    80004000:	8526                	mv	a0,s1
    80004002:	00002097          	auipc	ra,0x2
    80004006:	3e6080e7          	jalr	998(ra) # 800063e8 <release>
    kfree((char*)pi);
    8000400a:	8526                	mv	a0,s1
    8000400c:	ffffc097          	auipc	ra,0xffffc
    80004010:	010080e7          	jalr	16(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004014:	60e2                	ld	ra,24(sp)
    80004016:	6442                	ld	s0,16(sp)
    80004018:	64a2                	ld	s1,8(sp)
    8000401a:	6902                	ld	s2,0(sp)
    8000401c:	6105                	addi	sp,sp,32
    8000401e:	8082                	ret
    pi->readopen = 0;
    80004020:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004024:	21c48513          	addi	a0,s1,540
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	6a4080e7          	jalr	1700(ra) # 800016cc <wakeup>
    80004030:	b7e9                	j	80003ffa <pipeclose+0x2c>
    release(&pi->lock);
    80004032:	8526                	mv	a0,s1
    80004034:	00002097          	auipc	ra,0x2
    80004038:	3b4080e7          	jalr	948(ra) # 800063e8 <release>
}
    8000403c:	bfe1                	j	80004014 <pipeclose+0x46>

000000008000403e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000403e:	711d                	addi	sp,sp,-96
    80004040:	ec86                	sd	ra,88(sp)
    80004042:	e8a2                	sd	s0,80(sp)
    80004044:	e4a6                	sd	s1,72(sp)
    80004046:	e0ca                	sd	s2,64(sp)
    80004048:	fc4e                	sd	s3,56(sp)
    8000404a:	f852                	sd	s4,48(sp)
    8000404c:	f456                	sd	s5,40(sp)
    8000404e:	f05a                	sd	s6,32(sp)
    80004050:	ec5e                	sd	s7,24(sp)
    80004052:	e862                	sd	s8,16(sp)
    80004054:	1080                	addi	s0,sp,96
    80004056:	84aa                	mv	s1,a0
    80004058:	8aae                	mv	s5,a1
    8000405a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	ee2080e7          	jalr	-286(ra) # 80000f3e <myproc>
    80004064:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004066:	8526                	mv	a0,s1
    80004068:	00002097          	auipc	ra,0x2
    8000406c:	2cc080e7          	jalr	716(ra) # 80006334 <acquire>
  while(i < n){
    80004070:	0b405663          	blez	s4,8000411c <pipewrite+0xde>
  int i = 0;
    80004074:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004076:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004078:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000407c:	21c48b93          	addi	s7,s1,540
    80004080:	a089                	j	800040c2 <pipewrite+0x84>
      release(&pi->lock);
    80004082:	8526                	mv	a0,s1
    80004084:	00002097          	auipc	ra,0x2
    80004088:	364080e7          	jalr	868(ra) # 800063e8 <release>
      return -1;
    8000408c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000408e:	854a                	mv	a0,s2
    80004090:	60e6                	ld	ra,88(sp)
    80004092:	6446                	ld	s0,80(sp)
    80004094:	64a6                	ld	s1,72(sp)
    80004096:	6906                	ld	s2,64(sp)
    80004098:	79e2                	ld	s3,56(sp)
    8000409a:	7a42                	ld	s4,48(sp)
    8000409c:	7aa2                	ld	s5,40(sp)
    8000409e:	7b02                	ld	s6,32(sp)
    800040a0:	6be2                	ld	s7,24(sp)
    800040a2:	6c42                	ld	s8,16(sp)
    800040a4:	6125                	addi	sp,sp,96
    800040a6:	8082                	ret
      wakeup(&pi->nread);
    800040a8:	8562                	mv	a0,s8
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	622080e7          	jalr	1570(ra) # 800016cc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040b2:	85a6                	mv	a1,s1
    800040b4:	855e                	mv	a0,s7
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	5b2080e7          	jalr	1458(ra) # 80001668 <sleep>
  while(i < n){
    800040be:	07495063          	bge	s2,s4,8000411e <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    800040c2:	2204a783          	lw	a5,544(s1)
    800040c6:	dfd5                	beqz	a5,80004082 <pipewrite+0x44>
    800040c8:	854e                	mv	a0,s3
    800040ca:	ffffe097          	auipc	ra,0xffffe
    800040ce:	846080e7          	jalr	-1978(ra) # 80001910 <killed>
    800040d2:	f945                	bnez	a0,80004082 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040d4:	2184a783          	lw	a5,536(s1)
    800040d8:	21c4a703          	lw	a4,540(s1)
    800040dc:	2007879b          	addiw	a5,a5,512
    800040e0:	fcf704e3          	beq	a4,a5,800040a8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040e4:	4685                	li	a3,1
    800040e6:	01590633          	add	a2,s2,s5
    800040ea:	faf40593          	addi	a1,s0,-81
    800040ee:	0509b503          	ld	a0,80(s3)
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	aae080e7          	jalr	-1362(ra) # 80000ba0 <copyin>
    800040fa:	03650263          	beq	a0,s6,8000411e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040fe:	21c4a783          	lw	a5,540(s1)
    80004102:	0017871b          	addiw	a4,a5,1
    80004106:	20e4ae23          	sw	a4,540(s1)
    8000410a:	1ff7f793          	andi	a5,a5,511
    8000410e:	97a6                	add	a5,a5,s1
    80004110:	faf44703          	lbu	a4,-81(s0)
    80004114:	00e78c23          	sb	a4,24(a5)
      i++;
    80004118:	2905                	addiw	s2,s2,1
    8000411a:	b755                	j	800040be <pipewrite+0x80>
  int i = 0;
    8000411c:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000411e:	21848513          	addi	a0,s1,536
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	5aa080e7          	jalr	1450(ra) # 800016cc <wakeup>
  release(&pi->lock);
    8000412a:	8526                	mv	a0,s1
    8000412c:	00002097          	auipc	ra,0x2
    80004130:	2bc080e7          	jalr	700(ra) # 800063e8 <release>
  return i;
    80004134:	bfa9                	j	8000408e <pipewrite+0x50>

0000000080004136 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004136:	715d                	addi	sp,sp,-80
    80004138:	e486                	sd	ra,72(sp)
    8000413a:	e0a2                	sd	s0,64(sp)
    8000413c:	fc26                	sd	s1,56(sp)
    8000413e:	f84a                	sd	s2,48(sp)
    80004140:	f44e                	sd	s3,40(sp)
    80004142:	f052                	sd	s4,32(sp)
    80004144:	ec56                	sd	s5,24(sp)
    80004146:	e85a                	sd	s6,16(sp)
    80004148:	0880                	addi	s0,sp,80
    8000414a:	84aa                	mv	s1,a0
    8000414c:	892e                	mv	s2,a1
    8000414e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	dee080e7          	jalr	-530(ra) # 80000f3e <myproc>
    80004158:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000415a:	8526                	mv	a0,s1
    8000415c:	00002097          	auipc	ra,0x2
    80004160:	1d8080e7          	jalr	472(ra) # 80006334 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004164:	2184a703          	lw	a4,536(s1)
    80004168:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000416c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004170:	02f71763          	bne	a4,a5,8000419e <piperead+0x68>
    80004174:	2244a783          	lw	a5,548(s1)
    80004178:	c39d                	beqz	a5,8000419e <piperead+0x68>
    if(killed(pr)){
    8000417a:	8552                	mv	a0,s4
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	794080e7          	jalr	1940(ra) # 80001910 <killed>
    80004184:	e949                	bnez	a0,80004216 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004186:	85a6                	mv	a1,s1
    80004188:	854e                	mv	a0,s3
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	4de080e7          	jalr	1246(ra) # 80001668 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004192:	2184a703          	lw	a4,536(s1)
    80004196:	21c4a783          	lw	a5,540(s1)
    8000419a:	fcf70de3          	beq	a4,a5,80004174 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a2:	05505463          	blez	s5,800041ea <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800041a6:	2184a783          	lw	a5,536(s1)
    800041aa:	21c4a703          	lw	a4,540(s1)
    800041ae:	02f70e63          	beq	a4,a5,800041ea <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041b2:	0017871b          	addiw	a4,a5,1
    800041b6:	20e4ac23          	sw	a4,536(s1)
    800041ba:	1ff7f793          	andi	a5,a5,511
    800041be:	97a6                	add	a5,a5,s1
    800041c0:	0187c783          	lbu	a5,24(a5)
    800041c4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c8:	4685                	li	a3,1
    800041ca:	fbf40613          	addi	a2,s0,-65
    800041ce:	85ca                	mv	a1,s2
    800041d0:	050a3503          	ld	a0,80(s4)
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	940080e7          	jalr	-1728(ra) # 80000b14 <copyout>
    800041dc:	01650763          	beq	a0,s6,800041ea <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e0:	2985                	addiw	s3,s3,1
    800041e2:	0905                	addi	s2,s2,1
    800041e4:	fd3a91e3          	bne	s5,s3,800041a6 <piperead+0x70>
    800041e8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ea:	21c48513          	addi	a0,s1,540
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	4de080e7          	jalr	1246(ra) # 800016cc <wakeup>
  release(&pi->lock);
    800041f6:	8526                	mv	a0,s1
    800041f8:	00002097          	auipc	ra,0x2
    800041fc:	1f0080e7          	jalr	496(ra) # 800063e8 <release>
  return i;
}
    80004200:	854e                	mv	a0,s3
    80004202:	60a6                	ld	ra,72(sp)
    80004204:	6406                	ld	s0,64(sp)
    80004206:	74e2                	ld	s1,56(sp)
    80004208:	7942                	ld	s2,48(sp)
    8000420a:	79a2                	ld	s3,40(sp)
    8000420c:	7a02                	ld	s4,32(sp)
    8000420e:	6ae2                	ld	s5,24(sp)
    80004210:	6b42                	ld	s6,16(sp)
    80004212:	6161                	addi	sp,sp,80
    80004214:	8082                	ret
      release(&pi->lock);
    80004216:	8526                	mv	a0,s1
    80004218:	00002097          	auipc	ra,0x2
    8000421c:	1d0080e7          	jalr	464(ra) # 800063e8 <release>
      return -1;
    80004220:	59fd                	li	s3,-1
    80004222:	bff9                	j	80004200 <piperead+0xca>

0000000080004224 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004224:	1141                	addi	sp,sp,-16
    80004226:	e422                	sd	s0,8(sp)
    80004228:	0800                	addi	s0,sp,16
    8000422a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000422c:	8905                	andi	a0,a0,1
    8000422e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004230:	8b89                	andi	a5,a5,2
    80004232:	c399                	beqz	a5,80004238 <flags2perm+0x14>
      perm |= PTE_W;
    80004234:	00456513          	ori	a0,a0,4
    return perm;
}
    80004238:	6422                	ld	s0,8(sp)
    8000423a:	0141                	addi	sp,sp,16
    8000423c:	8082                	ret

000000008000423e <exec>:

int
exec(char *path, char **argv)
{
    8000423e:	de010113          	addi	sp,sp,-544
    80004242:	20113c23          	sd	ra,536(sp)
    80004246:	20813823          	sd	s0,528(sp)
    8000424a:	20913423          	sd	s1,520(sp)
    8000424e:	21213023          	sd	s2,512(sp)
    80004252:	ffce                	sd	s3,504(sp)
    80004254:	fbd2                	sd	s4,496(sp)
    80004256:	f7d6                	sd	s5,488(sp)
    80004258:	f3da                	sd	s6,480(sp)
    8000425a:	efde                	sd	s7,472(sp)
    8000425c:	ebe2                	sd	s8,464(sp)
    8000425e:	e7e6                	sd	s9,456(sp)
    80004260:	e3ea                	sd	s10,448(sp)
    80004262:	ff6e                	sd	s11,440(sp)
    80004264:	1400                	addi	s0,sp,544
    80004266:	892a                	mv	s2,a0
    80004268:	dea43423          	sd	a0,-536(s0)
    8000426c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	cce080e7          	jalr	-818(ra) # 80000f3e <myproc>
    80004278:	84aa                	mv	s1,a0

  begin_op();
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	482080e7          	jalr	1154(ra) # 800036fc <begin_op>

  if((ip = namei(path)) == 0){
    80004282:	854a                	mv	a0,s2
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	258080e7          	jalr	600(ra) # 800034dc <namei>
    8000428c:	c93d                	beqz	a0,80004302 <exec+0xc4>
    8000428e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	aa0080e7          	jalr	-1376(ra) # 80002d30 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004298:	04000713          	li	a4,64
    8000429c:	4681                	li	a3,0
    8000429e:	e5040613          	addi	a2,s0,-432
    800042a2:	4581                	li	a1,0
    800042a4:	8556                	mv	a0,s5
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	d3e080e7          	jalr	-706(ra) # 80002fe4 <readi>
    800042ae:	04000793          	li	a5,64
    800042b2:	00f51a63          	bne	a0,a5,800042c6 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042b6:	e5042703          	lw	a4,-432(s0)
    800042ba:	464c47b7          	lui	a5,0x464c4
    800042be:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042c2:	04f70663          	beq	a4,a5,8000430e <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042c6:	8556                	mv	a0,s5
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	cca080e7          	jalr	-822(ra) # 80002f92 <iunlockput>
    end_op();
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	4aa080e7          	jalr	1194(ra) # 8000377a <end_op>
  }
  return -1;
    800042d8:	557d                	li	a0,-1
}
    800042da:	21813083          	ld	ra,536(sp)
    800042de:	21013403          	ld	s0,528(sp)
    800042e2:	20813483          	ld	s1,520(sp)
    800042e6:	20013903          	ld	s2,512(sp)
    800042ea:	79fe                	ld	s3,504(sp)
    800042ec:	7a5e                	ld	s4,496(sp)
    800042ee:	7abe                	ld	s5,488(sp)
    800042f0:	7b1e                	ld	s6,480(sp)
    800042f2:	6bfe                	ld	s7,472(sp)
    800042f4:	6c5e                	ld	s8,464(sp)
    800042f6:	6cbe                	ld	s9,456(sp)
    800042f8:	6d1e                	ld	s10,448(sp)
    800042fa:	7dfa                	ld	s11,440(sp)
    800042fc:	22010113          	addi	sp,sp,544
    80004300:	8082                	ret
    end_op();
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	478080e7          	jalr	1144(ra) # 8000377a <end_op>
    return -1;
    8000430a:	557d                	li	a0,-1
    8000430c:	b7f9                	j	800042da <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000430e:	8526                	mv	a0,s1
    80004310:	ffffd097          	auipc	ra,0xffffd
    80004314:	cf2080e7          	jalr	-782(ra) # 80001002 <proc_pagetable>
    80004318:	8b2a                	mv	s6,a0
    8000431a:	d555                	beqz	a0,800042c6 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000431c:	e7042783          	lw	a5,-400(s0)
    80004320:	e8845703          	lhu	a4,-376(s0)
    80004324:	c735                	beqz	a4,80004390 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004326:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004328:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000432c:	6a05                	lui	s4,0x1
    8000432e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004332:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004336:	6d85                	lui	s11,0x1
    80004338:	7d7d                	lui	s10,0xfffff
    8000433a:	ac99                	j	80004590 <exec+0x352>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000433c:	00004517          	auipc	a0,0x4
    80004340:	3bc50513          	addi	a0,a0,956 # 800086f8 <syscalls+0x2f8>
    80004344:	00002097          	auipc	ra,0x2
    80004348:	ab8080e7          	jalr	-1352(ra) # 80005dfc <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000434c:	874a                	mv	a4,s2
    8000434e:	009c86bb          	addw	a3,s9,s1
    80004352:	4581                	li	a1,0
    80004354:	8556                	mv	a0,s5
    80004356:	fffff097          	auipc	ra,0xfffff
    8000435a:	c8e080e7          	jalr	-882(ra) # 80002fe4 <readi>
    8000435e:	2501                	sext.w	a0,a0
    80004360:	1ca91563          	bne	s2,a0,8000452a <exec+0x2ec>
  for(i = 0; i < sz; i += PGSIZE){
    80004364:	009d84bb          	addw	s1,s11,s1
    80004368:	013d09bb          	addw	s3,s10,s3
    8000436c:	2174f263          	bgeu	s1,s7,80004570 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    80004370:	02049593          	slli	a1,s1,0x20
    80004374:	9181                	srli	a1,a1,0x20
    80004376:	95e2                	add	a1,a1,s8
    80004378:	855a                	mv	a0,s6
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	18a080e7          	jalr	394(ra) # 80000504 <walkaddr>
    80004382:	862a                	mv	a2,a0
    if(pa == 0)
    80004384:	dd45                	beqz	a0,8000433c <exec+0xfe>
      n = PGSIZE;
    80004386:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004388:	fd49f2e3          	bgeu	s3,s4,8000434c <exec+0x10e>
      n = sz - i;
    8000438c:	894e                	mv	s2,s3
    8000438e:	bf7d                	j	8000434c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004390:	4901                	li	s2,0
  iunlockput(ip);
    80004392:	8556                	mv	a0,s5
    80004394:	fffff097          	auipc	ra,0xfffff
    80004398:	bfe080e7          	jalr	-1026(ra) # 80002f92 <iunlockput>
  end_op();
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	3de080e7          	jalr	990(ra) # 8000377a <end_op>
  p = myproc();
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	b9a080e7          	jalr	-1126(ra) # 80000f3e <myproc>
    800043ac:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800043ae:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043b2:	6785                	lui	a5,0x1
    800043b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800043b6:	97ca                	add	a5,a5,s2
    800043b8:	777d                	lui	a4,0xfffff
    800043ba:	8ff9                	and	a5,a5,a4
    800043bc:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043c0:	4691                	li	a3,4
    800043c2:	6609                	lui	a2,0x2
    800043c4:	963e                	add	a2,a2,a5
    800043c6:	85be                	mv	a1,a5
    800043c8:	855a                	mv	a0,s6
    800043ca:	ffffc097          	auipc	ra,0xffffc
    800043ce:	4ee080e7          	jalr	1262(ra) # 800008b8 <uvmalloc>
    800043d2:	8c2a                	mv	s8,a0
  ip = 0;
    800043d4:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043d6:	14050a63          	beqz	a0,8000452a <exec+0x2ec>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043da:	75f9                	lui	a1,0xffffe
    800043dc:	95aa                	add	a1,a1,a0
    800043de:	855a                	mv	a0,s6
    800043e0:	ffffc097          	auipc	ra,0xffffc
    800043e4:	702080e7          	jalr	1794(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    800043e8:	7afd                	lui	s5,0xfffff
    800043ea:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043ec:	df043783          	ld	a5,-528(s0)
    800043f0:	6388                	ld	a0,0(a5)
    800043f2:	c925                	beqz	a0,80004462 <exec+0x224>
    800043f4:	e9040993          	addi	s3,s0,-368
    800043f8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043fc:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043fe:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	ef6080e7          	jalr	-266(ra) # 800002f6 <strlen>
    80004408:	0015079b          	addiw	a5,a0,1
    8000440c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004410:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004414:	15596263          	bltu	s2,s5,80004558 <exec+0x31a>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004418:	df043d83          	ld	s11,-528(s0)
    8000441c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004420:	8552                	mv	a0,s4
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	ed4080e7          	jalr	-300(ra) # 800002f6 <strlen>
    8000442a:	0015069b          	addiw	a3,a0,1
    8000442e:	8652                	mv	a2,s4
    80004430:	85ca                	mv	a1,s2
    80004432:	855a                	mv	a0,s6
    80004434:	ffffc097          	auipc	ra,0xffffc
    80004438:	6e0080e7          	jalr	1760(ra) # 80000b14 <copyout>
    8000443c:	12054263          	bltz	a0,80004560 <exec+0x322>
    ustack[argc] = sp;
    80004440:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004444:	0485                	addi	s1,s1,1
    80004446:	008d8793          	addi	a5,s11,8
    8000444a:	def43823          	sd	a5,-528(s0)
    8000444e:	008db503          	ld	a0,8(s11)
    80004452:	c911                	beqz	a0,80004466 <exec+0x228>
    if(argc >= MAXARG)
    80004454:	09a1                	addi	s3,s3,8
    80004456:	fb3c95e3          	bne	s9,s3,80004400 <exec+0x1c2>
  sz = sz1;
    8000445a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000445e:	4a81                	li	s5,0
    80004460:	a0e9                	j	8000452a <exec+0x2ec>
  sp = sz;
    80004462:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004464:	4481                	li	s1,0
  ustack[argc] = 0;
    80004466:	00349793          	slli	a5,s1,0x3
    8000446a:	f9078793          	addi	a5,a5,-112
    8000446e:	97a2                	add	a5,a5,s0
    80004470:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004474:	00148693          	addi	a3,s1,1
    80004478:	068e                	slli	a3,a3,0x3
    8000447a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000447e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004482:	01597663          	bgeu	s2,s5,8000448e <exec+0x250>
  sz = sz1;
    80004486:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000448a:	4a81                	li	s5,0
    8000448c:	a879                	j	8000452a <exec+0x2ec>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000448e:	e9040613          	addi	a2,s0,-368
    80004492:	85ca                	mv	a1,s2
    80004494:	855a                	mv	a0,s6
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	67e080e7          	jalr	1662(ra) # 80000b14 <copyout>
    8000449e:	0c054563          	bltz	a0,80004568 <exec+0x32a>
  p->trapframe->a1 = sp;
    800044a2:	060bb783          	ld	a5,96(s7)
    800044a6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044aa:	de843783          	ld	a5,-536(s0)
    800044ae:	0007c703          	lbu	a4,0(a5)
    800044b2:	cf11                	beqz	a4,800044ce <exec+0x290>
    800044b4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044b6:	02f00693          	li	a3,47
    800044ba:	a039                	j	800044c8 <exec+0x28a>
      last = s+1;
    800044bc:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800044c0:	0785                	addi	a5,a5,1
    800044c2:	fff7c703          	lbu	a4,-1(a5)
    800044c6:	c701                	beqz	a4,800044ce <exec+0x290>
    if(*s == '/')
    800044c8:	fed71ce3          	bne	a4,a3,800044c0 <exec+0x282>
    800044cc:	bfc5                	j	800044bc <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800044ce:	4641                	li	a2,16
    800044d0:	de843583          	ld	a1,-536(s0)
    800044d4:	160b8513          	addi	a0,s7,352
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	dec080e7          	jalr	-532(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800044e0:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800044e4:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044e8:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044ec:	060bb783          	ld	a5,96(s7)
    800044f0:	e6843703          	ld	a4,-408(s0)
    800044f4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044f6:	060bb783          	ld	a5,96(s7)
    800044fa:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044fe:	85ea                	mv	a1,s10
    80004500:	ffffd097          	auipc	ra,0xffffd
    80004504:	bcc080e7          	jalr	-1076(ra) # 800010cc <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    80004508:	030ba703          	lw	a4,48(s7)
    8000450c:	4785                	li	a5,1
    8000450e:	00f70563          	beq	a4,a5,80004518 <exec+0x2da>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004512:	0004851b          	sext.w	a0,s1
    80004516:	b3d1                	j	800042da <exec+0x9c>
  if(p->pid==1) vmprint(p->pagetable);
    80004518:	050bb503          	ld	a0,80(s7)
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	7c2080e7          	jalr	1986(ra) # 80000cde <vmprint>
    80004524:	b7fd                	j	80004512 <exec+0x2d4>
    80004526:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000452a:	df843583          	ld	a1,-520(s0)
    8000452e:	855a                	mv	a0,s6
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	b9c080e7          	jalr	-1124(ra) # 800010cc <proc_freepagetable>
  if(ip){
    80004538:	d80a97e3          	bnez	s5,800042c6 <exec+0x88>
  return -1;
    8000453c:	557d                	li	a0,-1
    8000453e:	bb71                	j	800042da <exec+0x9c>
    80004540:	df243c23          	sd	s2,-520(s0)
    80004544:	b7dd                	j	8000452a <exec+0x2ec>
    80004546:	df243c23          	sd	s2,-520(s0)
    8000454a:	b7c5                	j	8000452a <exec+0x2ec>
    8000454c:	df243c23          	sd	s2,-520(s0)
    80004550:	bfe9                	j	8000452a <exec+0x2ec>
    80004552:	df243c23          	sd	s2,-520(s0)
    80004556:	bfd1                	j	8000452a <exec+0x2ec>
  sz = sz1;
    80004558:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000455c:	4a81                	li	s5,0
    8000455e:	b7f1                	j	8000452a <exec+0x2ec>
  sz = sz1;
    80004560:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004564:	4a81                	li	s5,0
    80004566:	b7d1                	j	8000452a <exec+0x2ec>
  sz = sz1;
    80004568:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000456c:	4a81                	li	s5,0
    8000456e:	bf75                	j	8000452a <exec+0x2ec>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004570:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004574:	e0843783          	ld	a5,-504(s0)
    80004578:	0017869b          	addiw	a3,a5,1
    8000457c:	e0d43423          	sd	a3,-504(s0)
    80004580:	e0043783          	ld	a5,-512(s0)
    80004584:	0387879b          	addiw	a5,a5,56
    80004588:	e8845703          	lhu	a4,-376(s0)
    8000458c:	e0e6d3e3          	bge	a3,a4,80004392 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004590:	2781                	sext.w	a5,a5
    80004592:	e0f43023          	sd	a5,-512(s0)
    80004596:	03800713          	li	a4,56
    8000459a:	86be                	mv	a3,a5
    8000459c:	e1840613          	addi	a2,s0,-488
    800045a0:	4581                	li	a1,0
    800045a2:	8556                	mv	a0,s5
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	a40080e7          	jalr	-1472(ra) # 80002fe4 <readi>
    800045ac:	03800793          	li	a5,56
    800045b0:	f6f51be3          	bne	a0,a5,80004526 <exec+0x2e8>
    if(ph.type != ELF_PROG_LOAD)
    800045b4:	e1842783          	lw	a5,-488(s0)
    800045b8:	4705                	li	a4,1
    800045ba:	fae79de3          	bne	a5,a4,80004574 <exec+0x336>
    if(ph.memsz < ph.filesz)
    800045be:	e4043483          	ld	s1,-448(s0)
    800045c2:	e3843783          	ld	a5,-456(s0)
    800045c6:	f6f4ede3          	bltu	s1,a5,80004540 <exec+0x302>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045ca:	e2843783          	ld	a5,-472(s0)
    800045ce:	94be                	add	s1,s1,a5
    800045d0:	f6f4ebe3          	bltu	s1,a5,80004546 <exec+0x308>
    if(ph.vaddr % PGSIZE != 0)
    800045d4:	de043703          	ld	a4,-544(s0)
    800045d8:	8ff9                	and	a5,a5,a4
    800045da:	fbad                	bnez	a5,8000454c <exec+0x30e>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045dc:	e1c42503          	lw	a0,-484(s0)
    800045e0:	00000097          	auipc	ra,0x0
    800045e4:	c44080e7          	jalr	-956(ra) # 80004224 <flags2perm>
    800045e8:	86aa                	mv	a3,a0
    800045ea:	8626                	mv	a2,s1
    800045ec:	85ca                	mv	a1,s2
    800045ee:	855a                	mv	a0,s6
    800045f0:	ffffc097          	auipc	ra,0xffffc
    800045f4:	2c8080e7          	jalr	712(ra) # 800008b8 <uvmalloc>
    800045f8:	dea43c23          	sd	a0,-520(s0)
    800045fc:	d939                	beqz	a0,80004552 <exec+0x314>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045fe:	e2843c03          	ld	s8,-472(s0)
    80004602:	e2042c83          	lw	s9,-480(s0)
    80004606:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000460a:	f60b83e3          	beqz	s7,80004570 <exec+0x332>
    8000460e:	89de                	mv	s3,s7
    80004610:	4481                	li	s1,0
    80004612:	bbb9                	j	80004370 <exec+0x132>

0000000080004614 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004614:	7179                	addi	sp,sp,-48
    80004616:	f406                	sd	ra,40(sp)
    80004618:	f022                	sd	s0,32(sp)
    8000461a:	ec26                	sd	s1,24(sp)
    8000461c:	e84a                	sd	s2,16(sp)
    8000461e:	1800                	addi	s0,sp,48
    80004620:	892e                	mv	s2,a1
    80004622:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004624:	fdc40593          	addi	a1,s0,-36
    80004628:	ffffe097          	auipc	ra,0xffffe
    8000462c:	aae080e7          	jalr	-1362(ra) # 800020d6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004630:	fdc42703          	lw	a4,-36(s0)
    80004634:	47bd                	li	a5,15
    80004636:	02e7eb63          	bltu	a5,a4,8000466c <argfd+0x58>
    8000463a:	ffffd097          	auipc	ra,0xffffd
    8000463e:	904080e7          	jalr	-1788(ra) # 80000f3e <myproc>
    80004642:	fdc42703          	lw	a4,-36(s0)
    80004646:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd01a>
    8000464a:	078e                	slli	a5,a5,0x3
    8000464c:	953e                	add	a0,a0,a5
    8000464e:	651c                	ld	a5,8(a0)
    80004650:	c385                	beqz	a5,80004670 <argfd+0x5c>
    return -1;
  if(pfd)
    80004652:	00090463          	beqz	s2,8000465a <argfd+0x46>
    *pfd = fd;
    80004656:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000465a:	4501                	li	a0,0
  if(pf)
    8000465c:	c091                	beqz	s1,80004660 <argfd+0x4c>
    *pf = f;
    8000465e:	e09c                	sd	a5,0(s1)
}
    80004660:	70a2                	ld	ra,40(sp)
    80004662:	7402                	ld	s0,32(sp)
    80004664:	64e2                	ld	s1,24(sp)
    80004666:	6942                	ld	s2,16(sp)
    80004668:	6145                	addi	sp,sp,48
    8000466a:	8082                	ret
    return -1;
    8000466c:	557d                	li	a0,-1
    8000466e:	bfcd                	j	80004660 <argfd+0x4c>
    80004670:	557d                	li	a0,-1
    80004672:	b7fd                	j	80004660 <argfd+0x4c>

0000000080004674 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004674:	1101                	addi	sp,sp,-32
    80004676:	ec06                	sd	ra,24(sp)
    80004678:	e822                	sd	s0,16(sp)
    8000467a:	e426                	sd	s1,8(sp)
    8000467c:	1000                	addi	s0,sp,32
    8000467e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004680:	ffffd097          	auipc	ra,0xffffd
    80004684:	8be080e7          	jalr	-1858(ra) # 80000f3e <myproc>
    80004688:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000468a:	0d850793          	addi	a5,a0,216
    8000468e:	4501                	li	a0,0
    80004690:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004692:	6398                	ld	a4,0(a5)
    80004694:	cb19                	beqz	a4,800046aa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004696:	2505                	addiw	a0,a0,1
    80004698:	07a1                	addi	a5,a5,8
    8000469a:	fed51ce3          	bne	a0,a3,80004692 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000469e:	557d                	li	a0,-1
}
    800046a0:	60e2                	ld	ra,24(sp)
    800046a2:	6442                	ld	s0,16(sp)
    800046a4:	64a2                	ld	s1,8(sp)
    800046a6:	6105                	addi	sp,sp,32
    800046a8:	8082                	ret
      p->ofile[fd] = f;
    800046aa:	01a50793          	addi	a5,a0,26
    800046ae:	078e                	slli	a5,a5,0x3
    800046b0:	963e                	add	a2,a2,a5
    800046b2:	e604                	sd	s1,8(a2)
      return fd;
    800046b4:	b7f5                	j	800046a0 <fdalloc+0x2c>

00000000800046b6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046b6:	715d                	addi	sp,sp,-80
    800046b8:	e486                	sd	ra,72(sp)
    800046ba:	e0a2                	sd	s0,64(sp)
    800046bc:	fc26                	sd	s1,56(sp)
    800046be:	f84a                	sd	s2,48(sp)
    800046c0:	f44e                	sd	s3,40(sp)
    800046c2:	f052                	sd	s4,32(sp)
    800046c4:	ec56                	sd	s5,24(sp)
    800046c6:	e85a                	sd	s6,16(sp)
    800046c8:	0880                	addi	s0,sp,80
    800046ca:	8b2e                	mv	s6,a1
    800046cc:	89b2                	mv	s3,a2
    800046ce:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046d0:	fb040593          	addi	a1,s0,-80
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	e26080e7          	jalr	-474(ra) # 800034fa <nameiparent>
    800046dc:	84aa                	mv	s1,a0
    800046de:	14050f63          	beqz	a0,8000483c <create+0x186>
    return 0;

  ilock(dp);
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	64e080e7          	jalr	1614(ra) # 80002d30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046ea:	4601                	li	a2,0
    800046ec:	fb040593          	addi	a1,s0,-80
    800046f0:	8526                	mv	a0,s1
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	b22080e7          	jalr	-1246(ra) # 80003214 <dirlookup>
    800046fa:	8aaa                	mv	s5,a0
    800046fc:	c931                	beqz	a0,80004750 <create+0x9a>
    iunlockput(dp);
    800046fe:	8526                	mv	a0,s1
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	892080e7          	jalr	-1902(ra) # 80002f92 <iunlockput>
    ilock(ip);
    80004708:	8556                	mv	a0,s5
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	626080e7          	jalr	1574(ra) # 80002d30 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004712:	000b059b          	sext.w	a1,s6
    80004716:	4789                	li	a5,2
    80004718:	02f59563          	bne	a1,a5,80004742 <create+0x8c>
    8000471c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd044>
    80004720:	37f9                	addiw	a5,a5,-2
    80004722:	17c2                	slli	a5,a5,0x30
    80004724:	93c1                	srli	a5,a5,0x30
    80004726:	4705                	li	a4,1
    80004728:	00f76d63          	bltu	a4,a5,80004742 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000472c:	8556                	mv	a0,s5
    8000472e:	60a6                	ld	ra,72(sp)
    80004730:	6406                	ld	s0,64(sp)
    80004732:	74e2                	ld	s1,56(sp)
    80004734:	7942                	ld	s2,48(sp)
    80004736:	79a2                	ld	s3,40(sp)
    80004738:	7a02                	ld	s4,32(sp)
    8000473a:	6ae2                	ld	s5,24(sp)
    8000473c:	6b42                	ld	s6,16(sp)
    8000473e:	6161                	addi	sp,sp,80
    80004740:	8082                	ret
    iunlockput(ip);
    80004742:	8556                	mv	a0,s5
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	84e080e7          	jalr	-1970(ra) # 80002f92 <iunlockput>
    return 0;
    8000474c:	4a81                	li	s5,0
    8000474e:	bff9                	j	8000472c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004750:	85da                	mv	a1,s6
    80004752:	4088                	lw	a0,0(s1)
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	43e080e7          	jalr	1086(ra) # 80002b92 <ialloc>
    8000475c:	8a2a                	mv	s4,a0
    8000475e:	c539                	beqz	a0,800047ac <create+0xf6>
  ilock(ip);
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	5d0080e7          	jalr	1488(ra) # 80002d30 <ilock>
  ip->major = major;
    80004768:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000476c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004770:	4905                	li	s2,1
    80004772:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004776:	8552                	mv	a0,s4
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	4ec080e7          	jalr	1260(ra) # 80002c64 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004780:	000b059b          	sext.w	a1,s6
    80004784:	03258b63          	beq	a1,s2,800047ba <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004788:	004a2603          	lw	a2,4(s4)
    8000478c:	fb040593          	addi	a1,s0,-80
    80004790:	8526                	mv	a0,s1
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	c98080e7          	jalr	-872(ra) # 8000342a <dirlink>
    8000479a:	06054f63          	bltz	a0,80004818 <create+0x162>
  iunlockput(dp);
    8000479e:	8526                	mv	a0,s1
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	7f2080e7          	jalr	2034(ra) # 80002f92 <iunlockput>
  return ip;
    800047a8:	8ad2                	mv	s5,s4
    800047aa:	b749                	j	8000472c <create+0x76>
    iunlockput(dp);
    800047ac:	8526                	mv	a0,s1
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	7e4080e7          	jalr	2020(ra) # 80002f92 <iunlockput>
    return 0;
    800047b6:	8ad2                	mv	s5,s4
    800047b8:	bf95                	j	8000472c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ba:	004a2603          	lw	a2,4(s4)
    800047be:	00004597          	auipc	a1,0x4
    800047c2:	f5a58593          	addi	a1,a1,-166 # 80008718 <syscalls+0x318>
    800047c6:	8552                	mv	a0,s4
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	c62080e7          	jalr	-926(ra) # 8000342a <dirlink>
    800047d0:	04054463          	bltz	a0,80004818 <create+0x162>
    800047d4:	40d0                	lw	a2,4(s1)
    800047d6:	00004597          	auipc	a1,0x4
    800047da:	99258593          	addi	a1,a1,-1646 # 80008168 <etext+0x168>
    800047de:	8552                	mv	a0,s4
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	c4a080e7          	jalr	-950(ra) # 8000342a <dirlink>
    800047e8:	02054863          	bltz	a0,80004818 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ec:	004a2603          	lw	a2,4(s4)
    800047f0:	fb040593          	addi	a1,s0,-80
    800047f4:	8526                	mv	a0,s1
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	c34080e7          	jalr	-972(ra) # 8000342a <dirlink>
    800047fe:	00054d63          	bltz	a0,80004818 <create+0x162>
    dp->nlink++;  // for ".."
    80004802:	04a4d783          	lhu	a5,74(s1)
    80004806:	2785                	addiw	a5,a5,1
    80004808:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000480c:	8526                	mv	a0,s1
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	456080e7          	jalr	1110(ra) # 80002c64 <iupdate>
    80004816:	b761                	j	8000479e <create+0xe8>
  ip->nlink = 0;
    80004818:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000481c:	8552                	mv	a0,s4
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	446080e7          	jalr	1094(ra) # 80002c64 <iupdate>
  iunlockput(ip);
    80004826:	8552                	mv	a0,s4
    80004828:	ffffe097          	auipc	ra,0xffffe
    8000482c:	76a080e7          	jalr	1898(ra) # 80002f92 <iunlockput>
  iunlockput(dp);
    80004830:	8526                	mv	a0,s1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	760080e7          	jalr	1888(ra) # 80002f92 <iunlockput>
  return 0;
    8000483a:	bdcd                	j	8000472c <create+0x76>
    return 0;
    8000483c:	8aaa                	mv	s5,a0
    8000483e:	b5fd                	j	8000472c <create+0x76>

0000000080004840 <sys_dup>:
{
    80004840:	7179                	addi	sp,sp,-48
    80004842:	f406                	sd	ra,40(sp)
    80004844:	f022                	sd	s0,32(sp)
    80004846:	ec26                	sd	s1,24(sp)
    80004848:	e84a                	sd	s2,16(sp)
    8000484a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000484c:	fd840613          	addi	a2,s0,-40
    80004850:	4581                	li	a1,0
    80004852:	4501                	li	a0,0
    80004854:	00000097          	auipc	ra,0x0
    80004858:	dc0080e7          	jalr	-576(ra) # 80004614 <argfd>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000485e:	02054363          	bltz	a0,80004884 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004862:	fd843903          	ld	s2,-40(s0)
    80004866:	854a                	mv	a0,s2
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	e0c080e7          	jalr	-500(ra) # 80004674 <fdalloc>
    80004870:	84aa                	mv	s1,a0
    return -1;
    80004872:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004874:	00054863          	bltz	a0,80004884 <sys_dup+0x44>
  filedup(f);
    80004878:	854a                	mv	a0,s2
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	2f8080e7          	jalr	760(ra) # 80003b72 <filedup>
  return fd;
    80004882:	87a6                	mv	a5,s1
}
    80004884:	853e                	mv	a0,a5
    80004886:	70a2                	ld	ra,40(sp)
    80004888:	7402                	ld	s0,32(sp)
    8000488a:	64e2                	ld	s1,24(sp)
    8000488c:	6942                	ld	s2,16(sp)
    8000488e:	6145                	addi	sp,sp,48
    80004890:	8082                	ret

0000000080004892 <sys_read>:
{
    80004892:	7179                	addi	sp,sp,-48
    80004894:	f406                	sd	ra,40(sp)
    80004896:	f022                	sd	s0,32(sp)
    80004898:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000489a:	fd840593          	addi	a1,s0,-40
    8000489e:	4505                	li	a0,1
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	856080e7          	jalr	-1962(ra) # 800020f6 <argaddr>
  argint(2, &n);
    800048a8:	fe440593          	addi	a1,s0,-28
    800048ac:	4509                	li	a0,2
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	828080e7          	jalr	-2008(ra) # 800020d6 <argint>
  if(argfd(0, 0, &f) < 0)
    800048b6:	fe840613          	addi	a2,s0,-24
    800048ba:	4581                	li	a1,0
    800048bc:	4501                	li	a0,0
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	d56080e7          	jalr	-682(ra) # 80004614 <argfd>
    800048c6:	87aa                	mv	a5,a0
    return -1;
    800048c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048ca:	0007cc63          	bltz	a5,800048e2 <sys_read+0x50>
  return fileread(f, p, n);
    800048ce:	fe442603          	lw	a2,-28(s0)
    800048d2:	fd843583          	ld	a1,-40(s0)
    800048d6:	fe843503          	ld	a0,-24(s0)
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	424080e7          	jalr	1060(ra) # 80003cfe <fileread>
}
    800048e2:	70a2                	ld	ra,40(sp)
    800048e4:	7402                	ld	s0,32(sp)
    800048e6:	6145                	addi	sp,sp,48
    800048e8:	8082                	ret

00000000800048ea <sys_write>:
{
    800048ea:	7179                	addi	sp,sp,-48
    800048ec:	f406                	sd	ra,40(sp)
    800048ee:	f022                	sd	s0,32(sp)
    800048f0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048f2:	fd840593          	addi	a1,s0,-40
    800048f6:	4505                	li	a0,1
    800048f8:	ffffd097          	auipc	ra,0xffffd
    800048fc:	7fe080e7          	jalr	2046(ra) # 800020f6 <argaddr>
  argint(2, &n);
    80004900:	fe440593          	addi	a1,s0,-28
    80004904:	4509                	li	a0,2
    80004906:	ffffd097          	auipc	ra,0xffffd
    8000490a:	7d0080e7          	jalr	2000(ra) # 800020d6 <argint>
  if(argfd(0, 0, &f) < 0)
    8000490e:	fe840613          	addi	a2,s0,-24
    80004912:	4581                	li	a1,0
    80004914:	4501                	li	a0,0
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	cfe080e7          	jalr	-770(ra) # 80004614 <argfd>
    8000491e:	87aa                	mv	a5,a0
    return -1;
    80004920:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004922:	0007cc63          	bltz	a5,8000493a <sys_write+0x50>
  return filewrite(f, p, n);
    80004926:	fe442603          	lw	a2,-28(s0)
    8000492a:	fd843583          	ld	a1,-40(s0)
    8000492e:	fe843503          	ld	a0,-24(s0)
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	48e080e7          	jalr	1166(ra) # 80003dc0 <filewrite>
}
    8000493a:	70a2                	ld	ra,40(sp)
    8000493c:	7402                	ld	s0,32(sp)
    8000493e:	6145                	addi	sp,sp,48
    80004940:	8082                	ret

0000000080004942 <sys_close>:
{
    80004942:	1101                	addi	sp,sp,-32
    80004944:	ec06                	sd	ra,24(sp)
    80004946:	e822                	sd	s0,16(sp)
    80004948:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000494a:	fe040613          	addi	a2,s0,-32
    8000494e:	fec40593          	addi	a1,s0,-20
    80004952:	4501                	li	a0,0
    80004954:	00000097          	auipc	ra,0x0
    80004958:	cc0080e7          	jalr	-832(ra) # 80004614 <argfd>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000495e:	02054463          	bltz	a0,80004986 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	5dc080e7          	jalr	1500(ra) # 80000f3e <myproc>
    8000496a:	fec42783          	lw	a5,-20(s0)
    8000496e:	07e9                	addi	a5,a5,26
    80004970:	078e                	slli	a5,a5,0x3
    80004972:	953e                	add	a0,a0,a5
    80004974:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004978:	fe043503          	ld	a0,-32(s0)
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	248080e7          	jalr	584(ra) # 80003bc4 <fileclose>
  return 0;
    80004984:	4781                	li	a5,0
}
    80004986:	853e                	mv	a0,a5
    80004988:	60e2                	ld	ra,24(sp)
    8000498a:	6442                	ld	s0,16(sp)
    8000498c:	6105                	addi	sp,sp,32
    8000498e:	8082                	ret

0000000080004990 <sys_fstat>:
{
    80004990:	1101                	addi	sp,sp,-32
    80004992:	ec06                	sd	ra,24(sp)
    80004994:	e822                	sd	s0,16(sp)
    80004996:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004998:	fe040593          	addi	a1,s0,-32
    8000499c:	4505                	li	a0,1
    8000499e:	ffffd097          	auipc	ra,0xffffd
    800049a2:	758080e7          	jalr	1880(ra) # 800020f6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049a6:	fe840613          	addi	a2,s0,-24
    800049aa:	4581                	li	a1,0
    800049ac:	4501                	li	a0,0
    800049ae:	00000097          	auipc	ra,0x0
    800049b2:	c66080e7          	jalr	-922(ra) # 80004614 <argfd>
    800049b6:	87aa                	mv	a5,a0
    return -1;
    800049b8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049ba:	0007ca63          	bltz	a5,800049ce <sys_fstat+0x3e>
  return filestat(f, st);
    800049be:	fe043583          	ld	a1,-32(s0)
    800049c2:	fe843503          	ld	a0,-24(s0)
    800049c6:	fffff097          	auipc	ra,0xfffff
    800049ca:	2c6080e7          	jalr	710(ra) # 80003c8c <filestat>
}
    800049ce:	60e2                	ld	ra,24(sp)
    800049d0:	6442                	ld	s0,16(sp)
    800049d2:	6105                	addi	sp,sp,32
    800049d4:	8082                	ret

00000000800049d6 <sys_link>:
{
    800049d6:	7169                	addi	sp,sp,-304
    800049d8:	f606                	sd	ra,296(sp)
    800049da:	f222                	sd	s0,288(sp)
    800049dc:	ee26                	sd	s1,280(sp)
    800049de:	ea4a                	sd	s2,272(sp)
    800049e0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049e2:	08000613          	li	a2,128
    800049e6:	ed040593          	addi	a1,s0,-304
    800049ea:	4501                	li	a0,0
    800049ec:	ffffd097          	auipc	ra,0xffffd
    800049f0:	72a080e7          	jalr	1834(ra) # 80002116 <argstr>
    return -1;
    800049f4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f6:	10054e63          	bltz	a0,80004b12 <sys_link+0x13c>
    800049fa:	08000613          	li	a2,128
    800049fe:	f5040593          	addi	a1,s0,-176
    80004a02:	4505                	li	a0,1
    80004a04:	ffffd097          	auipc	ra,0xffffd
    80004a08:	712080e7          	jalr	1810(ra) # 80002116 <argstr>
    return -1;
    80004a0c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a0e:	10054263          	bltz	a0,80004b12 <sys_link+0x13c>
  begin_op();
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	cea080e7          	jalr	-790(ra) # 800036fc <begin_op>
  if((ip = namei(old)) == 0){
    80004a1a:	ed040513          	addi	a0,s0,-304
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	abe080e7          	jalr	-1346(ra) # 800034dc <namei>
    80004a26:	84aa                	mv	s1,a0
    80004a28:	c551                	beqz	a0,80004ab4 <sys_link+0xde>
  ilock(ip);
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	306080e7          	jalr	774(ra) # 80002d30 <ilock>
  if(ip->type == T_DIR){
    80004a32:	04449703          	lh	a4,68(s1)
    80004a36:	4785                	li	a5,1
    80004a38:	08f70463          	beq	a4,a5,80004ac0 <sys_link+0xea>
  ip->nlink++;
    80004a3c:	04a4d783          	lhu	a5,74(s1)
    80004a40:	2785                	addiw	a5,a5,1
    80004a42:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a46:	8526                	mv	a0,s1
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	21c080e7          	jalr	540(ra) # 80002c64 <iupdate>
  iunlock(ip);
    80004a50:	8526                	mv	a0,s1
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	3a0080e7          	jalr	928(ra) # 80002df2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a5a:	fd040593          	addi	a1,s0,-48
    80004a5e:	f5040513          	addi	a0,s0,-176
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	a98080e7          	jalr	-1384(ra) # 800034fa <nameiparent>
    80004a6a:	892a                	mv	s2,a0
    80004a6c:	c935                	beqz	a0,80004ae0 <sys_link+0x10a>
  ilock(dp);
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	2c2080e7          	jalr	706(ra) # 80002d30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a76:	00092703          	lw	a4,0(s2)
    80004a7a:	409c                	lw	a5,0(s1)
    80004a7c:	04f71d63          	bne	a4,a5,80004ad6 <sys_link+0x100>
    80004a80:	40d0                	lw	a2,4(s1)
    80004a82:	fd040593          	addi	a1,s0,-48
    80004a86:	854a                	mv	a0,s2
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	9a2080e7          	jalr	-1630(ra) # 8000342a <dirlink>
    80004a90:	04054363          	bltz	a0,80004ad6 <sys_link+0x100>
  iunlockput(dp);
    80004a94:	854a                	mv	a0,s2
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	4fc080e7          	jalr	1276(ra) # 80002f92 <iunlockput>
  iput(ip);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	44a080e7          	jalr	1098(ra) # 80002eea <iput>
  end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	cd2080e7          	jalr	-814(ra) # 8000377a <end_op>
  return 0;
    80004ab0:	4781                	li	a5,0
    80004ab2:	a085                	j	80004b12 <sys_link+0x13c>
    end_op();
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	cc6080e7          	jalr	-826(ra) # 8000377a <end_op>
    return -1;
    80004abc:	57fd                	li	a5,-1
    80004abe:	a891                	j	80004b12 <sys_link+0x13c>
    iunlockput(ip);
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	4d0080e7          	jalr	1232(ra) # 80002f92 <iunlockput>
    end_op();
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	cb0080e7          	jalr	-848(ra) # 8000377a <end_op>
    return -1;
    80004ad2:	57fd                	li	a5,-1
    80004ad4:	a83d                	j	80004b12 <sys_link+0x13c>
    iunlockput(dp);
    80004ad6:	854a                	mv	a0,s2
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	4ba080e7          	jalr	1210(ra) # 80002f92 <iunlockput>
  ilock(ip);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	24e080e7          	jalr	590(ra) # 80002d30 <ilock>
  ip->nlink--;
    80004aea:	04a4d783          	lhu	a5,74(s1)
    80004aee:	37fd                	addiw	a5,a5,-1
    80004af0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	16e080e7          	jalr	366(ra) # 80002c64 <iupdate>
  iunlockput(ip);
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	492080e7          	jalr	1170(ra) # 80002f92 <iunlockput>
  end_op();
    80004b08:	fffff097          	auipc	ra,0xfffff
    80004b0c:	c72080e7          	jalr	-910(ra) # 8000377a <end_op>
  return -1;
    80004b10:	57fd                	li	a5,-1
}
    80004b12:	853e                	mv	a0,a5
    80004b14:	70b2                	ld	ra,296(sp)
    80004b16:	7412                	ld	s0,288(sp)
    80004b18:	64f2                	ld	s1,280(sp)
    80004b1a:	6952                	ld	s2,272(sp)
    80004b1c:	6155                	addi	sp,sp,304
    80004b1e:	8082                	ret

0000000080004b20 <sys_unlink>:
{
    80004b20:	7151                	addi	sp,sp,-240
    80004b22:	f586                	sd	ra,232(sp)
    80004b24:	f1a2                	sd	s0,224(sp)
    80004b26:	eda6                	sd	s1,216(sp)
    80004b28:	e9ca                	sd	s2,208(sp)
    80004b2a:	e5ce                	sd	s3,200(sp)
    80004b2c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b2e:	08000613          	li	a2,128
    80004b32:	f3040593          	addi	a1,s0,-208
    80004b36:	4501                	li	a0,0
    80004b38:	ffffd097          	auipc	ra,0xffffd
    80004b3c:	5de080e7          	jalr	1502(ra) # 80002116 <argstr>
    80004b40:	18054163          	bltz	a0,80004cc2 <sys_unlink+0x1a2>
  begin_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	bb8080e7          	jalr	-1096(ra) # 800036fc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b4c:	fb040593          	addi	a1,s0,-80
    80004b50:	f3040513          	addi	a0,s0,-208
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	9a6080e7          	jalr	-1626(ra) # 800034fa <nameiparent>
    80004b5c:	84aa                	mv	s1,a0
    80004b5e:	c979                	beqz	a0,80004c34 <sys_unlink+0x114>
  ilock(dp);
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	1d0080e7          	jalr	464(ra) # 80002d30 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b68:	00004597          	auipc	a1,0x4
    80004b6c:	bb058593          	addi	a1,a1,-1104 # 80008718 <syscalls+0x318>
    80004b70:	fb040513          	addi	a0,s0,-80
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	686080e7          	jalr	1670(ra) # 800031fa <namecmp>
    80004b7c:	14050a63          	beqz	a0,80004cd0 <sys_unlink+0x1b0>
    80004b80:	00003597          	auipc	a1,0x3
    80004b84:	5e858593          	addi	a1,a1,1512 # 80008168 <etext+0x168>
    80004b88:	fb040513          	addi	a0,s0,-80
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	66e080e7          	jalr	1646(ra) # 800031fa <namecmp>
    80004b94:	12050e63          	beqz	a0,80004cd0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b98:	f2c40613          	addi	a2,s0,-212
    80004b9c:	fb040593          	addi	a1,s0,-80
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	672080e7          	jalr	1650(ra) # 80003214 <dirlookup>
    80004baa:	892a                	mv	s2,a0
    80004bac:	12050263          	beqz	a0,80004cd0 <sys_unlink+0x1b0>
  ilock(ip);
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	180080e7          	jalr	384(ra) # 80002d30 <ilock>
  if(ip->nlink < 1)
    80004bb8:	04a91783          	lh	a5,74(s2)
    80004bbc:	08f05263          	blez	a5,80004c40 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bc0:	04491703          	lh	a4,68(s2)
    80004bc4:	4785                	li	a5,1
    80004bc6:	08f70563          	beq	a4,a5,80004c50 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bca:	4641                	li	a2,16
    80004bcc:	4581                	li	a1,0
    80004bce:	fc040513          	addi	a0,s0,-64
    80004bd2:	ffffb097          	auipc	ra,0xffffb
    80004bd6:	5a8080e7          	jalr	1448(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bda:	4741                	li	a4,16
    80004bdc:	f2c42683          	lw	a3,-212(s0)
    80004be0:	fc040613          	addi	a2,s0,-64
    80004be4:	4581                	li	a1,0
    80004be6:	8526                	mv	a0,s1
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	4f4080e7          	jalr	1268(ra) # 800030dc <writei>
    80004bf0:	47c1                	li	a5,16
    80004bf2:	0af51563          	bne	a0,a5,80004c9c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bf6:	04491703          	lh	a4,68(s2)
    80004bfa:	4785                	li	a5,1
    80004bfc:	0af70863          	beq	a4,a5,80004cac <sys_unlink+0x18c>
  iunlockput(dp);
    80004c00:	8526                	mv	a0,s1
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	390080e7          	jalr	912(ra) # 80002f92 <iunlockput>
  ip->nlink--;
    80004c0a:	04a95783          	lhu	a5,74(s2)
    80004c0e:	37fd                	addiw	a5,a5,-1
    80004c10:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c14:	854a                	mv	a0,s2
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	04e080e7          	jalr	78(ra) # 80002c64 <iupdate>
  iunlockput(ip);
    80004c1e:	854a                	mv	a0,s2
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	372080e7          	jalr	882(ra) # 80002f92 <iunlockput>
  end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	b52080e7          	jalr	-1198(ra) # 8000377a <end_op>
  return 0;
    80004c30:	4501                	li	a0,0
    80004c32:	a84d                	j	80004ce4 <sys_unlink+0x1c4>
    end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	b46080e7          	jalr	-1210(ra) # 8000377a <end_op>
    return -1;
    80004c3c:	557d                	li	a0,-1
    80004c3e:	a05d                	j	80004ce4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c40:	00004517          	auipc	a0,0x4
    80004c44:	ae050513          	addi	a0,a0,-1312 # 80008720 <syscalls+0x320>
    80004c48:	00001097          	auipc	ra,0x1
    80004c4c:	1b4080e7          	jalr	436(ra) # 80005dfc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c50:	04c92703          	lw	a4,76(s2)
    80004c54:	02000793          	li	a5,32
    80004c58:	f6e7f9e3          	bgeu	a5,a4,80004bca <sys_unlink+0xaa>
    80004c5c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c60:	4741                	li	a4,16
    80004c62:	86ce                	mv	a3,s3
    80004c64:	f1840613          	addi	a2,s0,-232
    80004c68:	4581                	li	a1,0
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	378080e7          	jalr	888(ra) # 80002fe4 <readi>
    80004c74:	47c1                	li	a5,16
    80004c76:	00f51b63          	bne	a0,a5,80004c8c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c7a:	f1845783          	lhu	a5,-232(s0)
    80004c7e:	e7a1                	bnez	a5,80004cc6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c80:	29c1                	addiw	s3,s3,16
    80004c82:	04c92783          	lw	a5,76(s2)
    80004c86:	fcf9ede3          	bltu	s3,a5,80004c60 <sys_unlink+0x140>
    80004c8a:	b781                	j	80004bca <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c8c:	00004517          	auipc	a0,0x4
    80004c90:	aac50513          	addi	a0,a0,-1364 # 80008738 <syscalls+0x338>
    80004c94:	00001097          	auipc	ra,0x1
    80004c98:	168080e7          	jalr	360(ra) # 80005dfc <panic>
    panic("unlink: writei");
    80004c9c:	00004517          	auipc	a0,0x4
    80004ca0:	ab450513          	addi	a0,a0,-1356 # 80008750 <syscalls+0x350>
    80004ca4:	00001097          	auipc	ra,0x1
    80004ca8:	158080e7          	jalr	344(ra) # 80005dfc <panic>
    dp->nlink--;
    80004cac:	04a4d783          	lhu	a5,74(s1)
    80004cb0:	37fd                	addiw	a5,a5,-1
    80004cb2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	ffffe097          	auipc	ra,0xffffe
    80004cbc:	fac080e7          	jalr	-84(ra) # 80002c64 <iupdate>
    80004cc0:	b781                	j	80004c00 <sys_unlink+0xe0>
    return -1;
    80004cc2:	557d                	li	a0,-1
    80004cc4:	a005                	j	80004ce4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	2ca080e7          	jalr	714(ra) # 80002f92 <iunlockput>
  iunlockput(dp);
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	2c0080e7          	jalr	704(ra) # 80002f92 <iunlockput>
  end_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	aa0080e7          	jalr	-1376(ra) # 8000377a <end_op>
  return -1;
    80004ce2:	557d                	li	a0,-1
}
    80004ce4:	70ae                	ld	ra,232(sp)
    80004ce6:	740e                	ld	s0,224(sp)
    80004ce8:	64ee                	ld	s1,216(sp)
    80004cea:	694e                	ld	s2,208(sp)
    80004cec:	69ae                	ld	s3,200(sp)
    80004cee:	616d                	addi	sp,sp,240
    80004cf0:	8082                	ret

0000000080004cf2 <sys_open>:

uint64
sys_open(void)
{
    80004cf2:	7131                	addi	sp,sp,-192
    80004cf4:	fd06                	sd	ra,184(sp)
    80004cf6:	f922                	sd	s0,176(sp)
    80004cf8:	f526                	sd	s1,168(sp)
    80004cfa:	f14a                	sd	s2,160(sp)
    80004cfc:	ed4e                	sd	s3,152(sp)
    80004cfe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d00:	f4c40593          	addi	a1,s0,-180
    80004d04:	4505                	li	a0,1
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	3d0080e7          	jalr	976(ra) # 800020d6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d0e:	08000613          	li	a2,128
    80004d12:	f5040593          	addi	a1,s0,-176
    80004d16:	4501                	li	a0,0
    80004d18:	ffffd097          	auipc	ra,0xffffd
    80004d1c:	3fe080e7          	jalr	1022(ra) # 80002116 <argstr>
    80004d20:	87aa                	mv	a5,a0
    return -1;
    80004d22:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d24:	0a07c963          	bltz	a5,80004dd6 <sys_open+0xe4>

  begin_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	9d4080e7          	jalr	-1580(ra) # 800036fc <begin_op>

  if(omode & O_CREATE){
    80004d30:	f4c42783          	lw	a5,-180(s0)
    80004d34:	2007f793          	andi	a5,a5,512
    80004d38:	cfc5                	beqz	a5,80004df0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d3a:	4681                	li	a3,0
    80004d3c:	4601                	li	a2,0
    80004d3e:	4589                	li	a1,2
    80004d40:	f5040513          	addi	a0,s0,-176
    80004d44:	00000097          	auipc	ra,0x0
    80004d48:	972080e7          	jalr	-1678(ra) # 800046b6 <create>
    80004d4c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d4e:	c959                	beqz	a0,80004de4 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d50:	04449703          	lh	a4,68(s1)
    80004d54:	478d                	li	a5,3
    80004d56:	00f71763          	bne	a4,a5,80004d64 <sys_open+0x72>
    80004d5a:	0464d703          	lhu	a4,70(s1)
    80004d5e:	47a5                	li	a5,9
    80004d60:	0ce7ed63          	bltu	a5,a4,80004e3a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	da4080e7          	jalr	-604(ra) # 80003b08 <filealloc>
    80004d6c:	89aa                	mv	s3,a0
    80004d6e:	10050363          	beqz	a0,80004e74 <sys_open+0x182>
    80004d72:	00000097          	auipc	ra,0x0
    80004d76:	902080e7          	jalr	-1790(ra) # 80004674 <fdalloc>
    80004d7a:	892a                	mv	s2,a0
    80004d7c:	0e054763          	bltz	a0,80004e6a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d80:	04449703          	lh	a4,68(s1)
    80004d84:	478d                	li	a5,3
    80004d86:	0cf70563          	beq	a4,a5,80004e50 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d8a:	4789                	li	a5,2
    80004d8c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d90:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d94:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d98:	f4c42783          	lw	a5,-180(s0)
    80004d9c:	0017c713          	xori	a4,a5,1
    80004da0:	8b05                	andi	a4,a4,1
    80004da2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004da6:	0037f713          	andi	a4,a5,3
    80004daa:	00e03733          	snez	a4,a4
    80004dae:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004db2:	4007f793          	andi	a5,a5,1024
    80004db6:	c791                	beqz	a5,80004dc2 <sys_open+0xd0>
    80004db8:	04449703          	lh	a4,68(s1)
    80004dbc:	4789                	li	a5,2
    80004dbe:	0af70063          	beq	a4,a5,80004e5e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	02e080e7          	jalr	46(ra) # 80002df2 <iunlock>
  end_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	9ae080e7          	jalr	-1618(ra) # 8000377a <end_op>

  return fd;
    80004dd4:	854a                	mv	a0,s2
}
    80004dd6:	70ea                	ld	ra,184(sp)
    80004dd8:	744a                	ld	s0,176(sp)
    80004dda:	74aa                	ld	s1,168(sp)
    80004ddc:	790a                	ld	s2,160(sp)
    80004dde:	69ea                	ld	s3,152(sp)
    80004de0:	6129                	addi	sp,sp,192
    80004de2:	8082                	ret
      end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	996080e7          	jalr	-1642(ra) # 8000377a <end_op>
      return -1;
    80004dec:	557d                	li	a0,-1
    80004dee:	b7e5                	j	80004dd6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004df0:	f5040513          	addi	a0,s0,-176
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	6e8080e7          	jalr	1768(ra) # 800034dc <namei>
    80004dfc:	84aa                	mv	s1,a0
    80004dfe:	c905                	beqz	a0,80004e2e <sys_open+0x13c>
    ilock(ip);
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	f30080e7          	jalr	-208(ra) # 80002d30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e08:	04449703          	lh	a4,68(s1)
    80004e0c:	4785                	li	a5,1
    80004e0e:	f4f711e3          	bne	a4,a5,80004d50 <sys_open+0x5e>
    80004e12:	f4c42783          	lw	a5,-180(s0)
    80004e16:	d7b9                	beqz	a5,80004d64 <sys_open+0x72>
      iunlockput(ip);
    80004e18:	8526                	mv	a0,s1
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	178080e7          	jalr	376(ra) # 80002f92 <iunlockput>
      end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	958080e7          	jalr	-1704(ra) # 8000377a <end_op>
      return -1;
    80004e2a:	557d                	li	a0,-1
    80004e2c:	b76d                	j	80004dd6 <sys_open+0xe4>
      end_op();
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	94c080e7          	jalr	-1716(ra) # 8000377a <end_op>
      return -1;
    80004e36:	557d                	li	a0,-1
    80004e38:	bf79                	j	80004dd6 <sys_open+0xe4>
    iunlockput(ip);
    80004e3a:	8526                	mv	a0,s1
    80004e3c:	ffffe097          	auipc	ra,0xffffe
    80004e40:	156080e7          	jalr	342(ra) # 80002f92 <iunlockput>
    end_op();
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	936080e7          	jalr	-1738(ra) # 8000377a <end_op>
    return -1;
    80004e4c:	557d                	li	a0,-1
    80004e4e:	b761                	j	80004dd6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e50:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e54:	04649783          	lh	a5,70(s1)
    80004e58:	02f99223          	sh	a5,36(s3)
    80004e5c:	bf25                	j	80004d94 <sys_open+0xa2>
    itrunc(ip);
    80004e5e:	8526                	mv	a0,s1
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	fde080e7          	jalr	-34(ra) # 80002e3e <itrunc>
    80004e68:	bfa9                	j	80004dc2 <sys_open+0xd0>
      fileclose(f);
    80004e6a:	854e                	mv	a0,s3
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	d58080e7          	jalr	-680(ra) # 80003bc4 <fileclose>
    iunlockput(ip);
    80004e74:	8526                	mv	a0,s1
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	11c080e7          	jalr	284(ra) # 80002f92 <iunlockput>
    end_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	8fc080e7          	jalr	-1796(ra) # 8000377a <end_op>
    return -1;
    80004e86:	557d                	li	a0,-1
    80004e88:	b7b9                	j	80004dd6 <sys_open+0xe4>

0000000080004e8a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e8a:	7175                	addi	sp,sp,-144
    80004e8c:	e506                	sd	ra,136(sp)
    80004e8e:	e122                	sd	s0,128(sp)
    80004e90:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	86a080e7          	jalr	-1942(ra) # 800036fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e9a:	08000613          	li	a2,128
    80004e9e:	f7040593          	addi	a1,s0,-144
    80004ea2:	4501                	li	a0,0
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	272080e7          	jalr	626(ra) # 80002116 <argstr>
    80004eac:	02054963          	bltz	a0,80004ede <sys_mkdir+0x54>
    80004eb0:	4681                	li	a3,0
    80004eb2:	4601                	li	a2,0
    80004eb4:	4585                	li	a1,1
    80004eb6:	f7040513          	addi	a0,s0,-144
    80004eba:	fffff097          	auipc	ra,0xfffff
    80004ebe:	7fc080e7          	jalr	2044(ra) # 800046b6 <create>
    80004ec2:	cd11                	beqz	a0,80004ede <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	0ce080e7          	jalr	206(ra) # 80002f92 <iunlockput>
  end_op();
    80004ecc:	fffff097          	auipc	ra,0xfffff
    80004ed0:	8ae080e7          	jalr	-1874(ra) # 8000377a <end_op>
  return 0;
    80004ed4:	4501                	li	a0,0
}
    80004ed6:	60aa                	ld	ra,136(sp)
    80004ed8:	640a                	ld	s0,128(sp)
    80004eda:	6149                	addi	sp,sp,144
    80004edc:	8082                	ret
    end_op();
    80004ede:	fffff097          	auipc	ra,0xfffff
    80004ee2:	89c080e7          	jalr	-1892(ra) # 8000377a <end_op>
    return -1;
    80004ee6:	557d                	li	a0,-1
    80004ee8:	b7fd                	j	80004ed6 <sys_mkdir+0x4c>

0000000080004eea <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eea:	7135                	addi	sp,sp,-160
    80004eec:	ed06                	sd	ra,152(sp)
    80004eee:	e922                	sd	s0,144(sp)
    80004ef0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	80a080e7          	jalr	-2038(ra) # 800036fc <begin_op>
  argint(1, &major);
    80004efa:	f6c40593          	addi	a1,s0,-148
    80004efe:	4505                	li	a0,1
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	1d6080e7          	jalr	470(ra) # 800020d6 <argint>
  argint(2, &minor);
    80004f08:	f6840593          	addi	a1,s0,-152
    80004f0c:	4509                	li	a0,2
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	1c8080e7          	jalr	456(ra) # 800020d6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f16:	08000613          	li	a2,128
    80004f1a:	f7040593          	addi	a1,s0,-144
    80004f1e:	4501                	li	a0,0
    80004f20:	ffffd097          	auipc	ra,0xffffd
    80004f24:	1f6080e7          	jalr	502(ra) # 80002116 <argstr>
    80004f28:	02054b63          	bltz	a0,80004f5e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f2c:	f6841683          	lh	a3,-152(s0)
    80004f30:	f6c41603          	lh	a2,-148(s0)
    80004f34:	458d                	li	a1,3
    80004f36:	f7040513          	addi	a0,s0,-144
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	77c080e7          	jalr	1916(ra) # 800046b6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f42:	cd11                	beqz	a0,80004f5e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	04e080e7          	jalr	78(ra) # 80002f92 <iunlockput>
  end_op();
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	82e080e7          	jalr	-2002(ra) # 8000377a <end_op>
  return 0;
    80004f54:	4501                	li	a0,0
}
    80004f56:	60ea                	ld	ra,152(sp)
    80004f58:	644a                	ld	s0,144(sp)
    80004f5a:	610d                	addi	sp,sp,160
    80004f5c:	8082                	ret
    end_op();
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	81c080e7          	jalr	-2020(ra) # 8000377a <end_op>
    return -1;
    80004f66:	557d                	li	a0,-1
    80004f68:	b7fd                	j	80004f56 <sys_mknod+0x6c>

0000000080004f6a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f6a:	7135                	addi	sp,sp,-160
    80004f6c:	ed06                	sd	ra,152(sp)
    80004f6e:	e922                	sd	s0,144(sp)
    80004f70:	e526                	sd	s1,136(sp)
    80004f72:	e14a                	sd	s2,128(sp)
    80004f74:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f76:	ffffc097          	auipc	ra,0xffffc
    80004f7a:	fc8080e7          	jalr	-56(ra) # 80000f3e <myproc>
    80004f7e:	892a                	mv	s2,a0
  
  begin_op();
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	77c080e7          	jalr	1916(ra) # 800036fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f88:	08000613          	li	a2,128
    80004f8c:	f6040593          	addi	a1,s0,-160
    80004f90:	4501                	li	a0,0
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	184080e7          	jalr	388(ra) # 80002116 <argstr>
    80004f9a:	04054b63          	bltz	a0,80004ff0 <sys_chdir+0x86>
    80004f9e:	f6040513          	addi	a0,s0,-160
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	53a080e7          	jalr	1338(ra) # 800034dc <namei>
    80004faa:	84aa                	mv	s1,a0
    80004fac:	c131                	beqz	a0,80004ff0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	d82080e7          	jalr	-638(ra) # 80002d30 <ilock>
  if(ip->type != T_DIR){
    80004fb6:	04449703          	lh	a4,68(s1)
    80004fba:	4785                	li	a5,1
    80004fbc:	04f71063          	bne	a4,a5,80004ffc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	e30080e7          	jalr	-464(ra) # 80002df2 <iunlock>
  iput(p->cwd);
    80004fca:	15893503          	ld	a0,344(s2)
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	f1c080e7          	jalr	-228(ra) # 80002eea <iput>
  end_op();
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	7a4080e7          	jalr	1956(ra) # 8000377a <end_op>
  p->cwd = ip;
    80004fde:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fe2:	4501                	li	a0,0
}
    80004fe4:	60ea                	ld	ra,152(sp)
    80004fe6:	644a                	ld	s0,144(sp)
    80004fe8:	64aa                	ld	s1,136(sp)
    80004fea:	690a                	ld	s2,128(sp)
    80004fec:	610d                	addi	sp,sp,160
    80004fee:	8082                	ret
    end_op();
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	78a080e7          	jalr	1930(ra) # 8000377a <end_op>
    return -1;
    80004ff8:	557d                	li	a0,-1
    80004ffa:	b7ed                	j	80004fe4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	f94080e7          	jalr	-108(ra) # 80002f92 <iunlockput>
    end_op();
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	774080e7          	jalr	1908(ra) # 8000377a <end_op>
    return -1;
    8000500e:	557d                	li	a0,-1
    80005010:	bfd1                	j	80004fe4 <sys_chdir+0x7a>

0000000080005012 <sys_exec>:

uint64
sys_exec(void)
{
    80005012:	7145                	addi	sp,sp,-464
    80005014:	e786                	sd	ra,456(sp)
    80005016:	e3a2                	sd	s0,448(sp)
    80005018:	ff26                	sd	s1,440(sp)
    8000501a:	fb4a                	sd	s2,432(sp)
    8000501c:	f74e                	sd	s3,424(sp)
    8000501e:	f352                	sd	s4,416(sp)
    80005020:	ef56                	sd	s5,408(sp)
    80005022:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005024:	e3840593          	addi	a1,s0,-456
    80005028:	4505                	li	a0,1
    8000502a:	ffffd097          	auipc	ra,0xffffd
    8000502e:	0cc080e7          	jalr	204(ra) # 800020f6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005032:	08000613          	li	a2,128
    80005036:	f4040593          	addi	a1,s0,-192
    8000503a:	4501                	li	a0,0
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	0da080e7          	jalr	218(ra) # 80002116 <argstr>
    80005044:	87aa                	mv	a5,a0
    return -1;
    80005046:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005048:	0c07c363          	bltz	a5,8000510e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000504c:	10000613          	li	a2,256
    80005050:	4581                	li	a1,0
    80005052:	e4040513          	addi	a0,s0,-448
    80005056:	ffffb097          	auipc	ra,0xffffb
    8000505a:	124080e7          	jalr	292(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000505e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005062:	89a6                	mv	s3,s1
    80005064:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005066:	02000a13          	li	s4,32
    8000506a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000506e:	00391513          	slli	a0,s2,0x3
    80005072:	e3040593          	addi	a1,s0,-464
    80005076:	e3843783          	ld	a5,-456(s0)
    8000507a:	953e                	add	a0,a0,a5
    8000507c:	ffffd097          	auipc	ra,0xffffd
    80005080:	fbc080e7          	jalr	-68(ra) # 80002038 <fetchaddr>
    80005084:	02054a63          	bltz	a0,800050b8 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005088:	e3043783          	ld	a5,-464(s0)
    8000508c:	c3b9                	beqz	a5,800050d2 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000508e:	ffffb097          	auipc	ra,0xffffb
    80005092:	08c080e7          	jalr	140(ra) # 8000011a <kalloc>
    80005096:	85aa                	mv	a1,a0
    80005098:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000509c:	cd11                	beqz	a0,800050b8 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000509e:	6605                	lui	a2,0x1
    800050a0:	e3043503          	ld	a0,-464(s0)
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	fe6080e7          	jalr	-26(ra) # 8000208a <fetchstr>
    800050ac:	00054663          	bltz	a0,800050b8 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050b0:	0905                	addi	s2,s2,1
    800050b2:	09a1                	addi	s3,s3,8
    800050b4:	fb491be3          	bne	s2,s4,8000506a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b8:	f4040913          	addi	s2,s0,-192
    800050bc:	6088                	ld	a0,0(s1)
    800050be:	c539                	beqz	a0,8000510c <sys_exec+0xfa>
    kfree(argv[i]);
    800050c0:	ffffb097          	auipc	ra,0xffffb
    800050c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c8:	04a1                	addi	s1,s1,8
    800050ca:	ff2499e3          	bne	s1,s2,800050bc <sys_exec+0xaa>
  return -1;
    800050ce:	557d                	li	a0,-1
    800050d0:	a83d                	j	8000510e <sys_exec+0xfc>
      argv[i] = 0;
    800050d2:	0a8e                	slli	s5,s5,0x3
    800050d4:	fc0a8793          	addi	a5,s5,-64
    800050d8:	00878ab3          	add	s5,a5,s0
    800050dc:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050e0:	e4040593          	addi	a1,s0,-448
    800050e4:	f4040513          	addi	a0,s0,-192
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	156080e7          	jalr	342(ra) # 8000423e <exec>
    800050f0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f2:	f4040993          	addi	s3,s0,-192
    800050f6:	6088                	ld	a0,0(s1)
    800050f8:	c901                	beqz	a0,80005108 <sys_exec+0xf6>
    kfree(argv[i]);
    800050fa:	ffffb097          	auipc	ra,0xffffb
    800050fe:	f22080e7          	jalr	-222(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005102:	04a1                	addi	s1,s1,8
    80005104:	ff3499e3          	bne	s1,s3,800050f6 <sys_exec+0xe4>
  return ret;
    80005108:	854a                	mv	a0,s2
    8000510a:	a011                	j	8000510e <sys_exec+0xfc>
  return -1;
    8000510c:	557d                	li	a0,-1
}
    8000510e:	60be                	ld	ra,456(sp)
    80005110:	641e                	ld	s0,448(sp)
    80005112:	74fa                	ld	s1,440(sp)
    80005114:	795a                	ld	s2,432(sp)
    80005116:	79ba                	ld	s3,424(sp)
    80005118:	7a1a                	ld	s4,416(sp)
    8000511a:	6afa                	ld	s5,408(sp)
    8000511c:	6179                	addi	sp,sp,464
    8000511e:	8082                	ret

0000000080005120 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005120:	7139                	addi	sp,sp,-64
    80005122:	fc06                	sd	ra,56(sp)
    80005124:	f822                	sd	s0,48(sp)
    80005126:	f426                	sd	s1,40(sp)
    80005128:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	e14080e7          	jalr	-492(ra) # 80000f3e <myproc>
    80005132:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005134:	fd840593          	addi	a1,s0,-40
    80005138:	4501                	li	a0,0
    8000513a:	ffffd097          	auipc	ra,0xffffd
    8000513e:	fbc080e7          	jalr	-68(ra) # 800020f6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005142:	fc840593          	addi	a1,s0,-56
    80005146:	fd040513          	addi	a0,s0,-48
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	daa080e7          	jalr	-598(ra) # 80003ef4 <pipealloc>
    return -1;
    80005152:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005154:	0c054463          	bltz	a0,8000521c <sys_pipe+0xfc>
  fd0 = -1;
    80005158:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000515c:	fd043503          	ld	a0,-48(s0)
    80005160:	fffff097          	auipc	ra,0xfffff
    80005164:	514080e7          	jalr	1300(ra) # 80004674 <fdalloc>
    80005168:	fca42223          	sw	a0,-60(s0)
    8000516c:	08054b63          	bltz	a0,80005202 <sys_pipe+0xe2>
    80005170:	fc843503          	ld	a0,-56(s0)
    80005174:	fffff097          	auipc	ra,0xfffff
    80005178:	500080e7          	jalr	1280(ra) # 80004674 <fdalloc>
    8000517c:	fca42023          	sw	a0,-64(s0)
    80005180:	06054863          	bltz	a0,800051f0 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005184:	4691                	li	a3,4
    80005186:	fc440613          	addi	a2,s0,-60
    8000518a:	fd843583          	ld	a1,-40(s0)
    8000518e:	68a8                	ld	a0,80(s1)
    80005190:	ffffc097          	auipc	ra,0xffffc
    80005194:	984080e7          	jalr	-1660(ra) # 80000b14 <copyout>
    80005198:	02054063          	bltz	a0,800051b8 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000519c:	4691                	li	a3,4
    8000519e:	fc040613          	addi	a2,s0,-64
    800051a2:	fd843583          	ld	a1,-40(s0)
    800051a6:	0591                	addi	a1,a1,4
    800051a8:	68a8                	ld	a0,80(s1)
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	96a080e7          	jalr	-1686(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051b2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051b4:	06055463          	bgez	a0,8000521c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051b8:	fc442783          	lw	a5,-60(s0)
    800051bc:	07e9                	addi	a5,a5,26
    800051be:	078e                	slli	a5,a5,0x3
    800051c0:	97a6                	add	a5,a5,s1
    800051c2:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051c6:	fc042783          	lw	a5,-64(s0)
    800051ca:	07e9                	addi	a5,a5,26
    800051cc:	078e                	slli	a5,a5,0x3
    800051ce:	94be                	add	s1,s1,a5
    800051d0:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800051d4:	fd043503          	ld	a0,-48(s0)
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	9ec080e7          	jalr	-1556(ra) # 80003bc4 <fileclose>
    fileclose(wf);
    800051e0:	fc843503          	ld	a0,-56(s0)
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	9e0080e7          	jalr	-1568(ra) # 80003bc4 <fileclose>
    return -1;
    800051ec:	57fd                	li	a5,-1
    800051ee:	a03d                	j	8000521c <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051f0:	fc442783          	lw	a5,-60(s0)
    800051f4:	0007c763          	bltz	a5,80005202 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051f8:	07e9                	addi	a5,a5,26
    800051fa:	078e                	slli	a5,a5,0x3
    800051fc:	97a6                	add	a5,a5,s1
    800051fe:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005202:	fd043503          	ld	a0,-48(s0)
    80005206:	fffff097          	auipc	ra,0xfffff
    8000520a:	9be080e7          	jalr	-1602(ra) # 80003bc4 <fileclose>
    fileclose(wf);
    8000520e:	fc843503          	ld	a0,-56(s0)
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	9b2080e7          	jalr	-1614(ra) # 80003bc4 <fileclose>
    return -1;
    8000521a:	57fd                	li	a5,-1
}
    8000521c:	853e                	mv	a0,a5
    8000521e:	70e2                	ld	ra,56(sp)
    80005220:	7442                	ld	s0,48(sp)
    80005222:	74a2                	ld	s1,40(sp)
    80005224:	6121                	addi	sp,sp,64
    80005226:	8082                	ret
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	addi	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	fc22                	sd	s0,56(sp)
    80005242:	e0a6                	sd	s1,64(sp)
    80005244:	e4aa                	sd	a0,72(sp)
    80005246:	e8ae                	sd	a1,80(sp)
    80005248:	ecb2                	sd	a2,88(sp)
    8000524a:	f0b6                	sd	a3,96(sp)
    8000524c:	f4ba                	sd	a4,104(sp)
    8000524e:	f8be                	sd	a5,112(sp)
    80005250:	fcc2                	sd	a6,120(sp)
    80005252:	e146                	sd	a7,128(sp)
    80005254:	e54a                	sd	s2,136(sp)
    80005256:	e94e                	sd	s3,144(sp)
    80005258:	ed52                	sd	s4,152(sp)
    8000525a:	f156                	sd	s5,160(sp)
    8000525c:	f55a                	sd	s6,168(sp)
    8000525e:	f95e                	sd	s7,176(sp)
    80005260:	fd62                	sd	s8,184(sp)
    80005262:	e1e6                	sd	s9,192(sp)
    80005264:	e5ea                	sd	s10,200(sp)
    80005266:	e9ee                	sd	s11,208(sp)
    80005268:	edf2                	sd	t3,216(sp)
    8000526a:	f1f6                	sd	t4,224(sp)
    8000526c:	f5fa                	sd	t5,232(sp)
    8000526e:	f9fe                	sd	t6,240(sp)
    80005270:	c95fc0ef          	jal	ra,80001f04 <kerneltrap>
    80005274:	6082                	ld	ra,0(sp)
    80005276:	6122                	ld	sp,8(sp)
    80005278:	61c2                	ld	gp,16(sp)
    8000527a:	7282                	ld	t0,32(sp)
    8000527c:	7322                	ld	t1,40(sp)
    8000527e:	73c2                	ld	t2,48(sp)
    80005280:	7462                	ld	s0,56(sp)
    80005282:	6486                	ld	s1,64(sp)
    80005284:	6526                	ld	a0,72(sp)
    80005286:	65c6                	ld	a1,80(sp)
    80005288:	6666                	ld	a2,88(sp)
    8000528a:	7686                	ld	a3,96(sp)
    8000528c:	7726                	ld	a4,104(sp)
    8000528e:	77c6                	ld	a5,112(sp)
    80005290:	7866                	ld	a6,120(sp)
    80005292:	688a                	ld	a7,128(sp)
    80005294:	692a                	ld	s2,136(sp)
    80005296:	69ca                	ld	s3,144(sp)
    80005298:	6a6a                	ld	s4,152(sp)
    8000529a:	7a8a                	ld	s5,160(sp)
    8000529c:	7b2a                	ld	s6,168(sp)
    8000529e:	7bca                	ld	s7,176(sp)
    800052a0:	7c6a                	ld	s8,184(sp)
    800052a2:	6c8e                	ld	s9,192(sp)
    800052a4:	6d2e                	ld	s10,200(sp)
    800052a6:	6dce                	ld	s11,208(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
    800052b6:	00000013          	nop
    800052ba:	00000013          	nop
    800052be:	0001                	nop

00000000800052c0 <timervec>:
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	e10c                	sd	a1,0(a0)
    800052c6:	e510                	sd	a2,8(a0)
    800052c8:	e914                	sd	a3,16(a0)
    800052ca:	6d0c                	ld	a1,24(a0)
    800052cc:	7110                	ld	a2,32(a0)
    800052ce:	6194                	ld	a3,0(a1)
    800052d0:	96b2                	add	a3,a3,a2
    800052d2:	e194                	sd	a3,0(a1)
    800052d4:	4589                	li	a1,2
    800052d6:	14459073          	csrw	sip,a1
    800052da:	6914                	ld	a3,16(a0)
    800052dc:	6510                	ld	a2,8(a0)
    800052de:	610c                	ld	a1,0(a0)
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	30200073          	mret
	...

00000000800052ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e422                	sd	s0,8(sp)
    800052ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052f0:	0c0007b7          	lui	a5,0xc000
    800052f4:	4705                	li	a4,1
    800052f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052f8:	c3d8                	sw	a4,4(a5)
}
    800052fa:	6422                	ld	s0,8(sp)
    800052fc:	0141                	addi	sp,sp,16
    800052fe:	8082                	ret

0000000080005300 <plicinithart>:

void
plicinithart(void)
{
    80005300:	1141                	addi	sp,sp,-16
    80005302:	e406                	sd	ra,8(sp)
    80005304:	e022                	sd	s0,0(sp)
    80005306:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	c0a080e7          	jalr	-1014(ra) # 80000f12 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005310:	0085171b          	slliw	a4,a0,0x8
    80005314:	0c0027b7          	lui	a5,0xc002
    80005318:	97ba                	add	a5,a5,a4
    8000531a:	40200713          	li	a4,1026
    8000531e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005322:	00d5151b          	slliw	a0,a0,0xd
    80005326:	0c2017b7          	lui	a5,0xc201
    8000532a:	97aa                	add	a5,a5,a0
    8000532c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005330:	60a2                	ld	ra,8(sp)
    80005332:	6402                	ld	s0,0(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005338:	1141                	addi	sp,sp,-16
    8000533a:	e406                	sd	ra,8(sp)
    8000533c:	e022                	sd	s0,0(sp)
    8000533e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005340:	ffffc097          	auipc	ra,0xffffc
    80005344:	bd2080e7          	jalr	-1070(ra) # 80000f12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005348:	00d5151b          	slliw	a0,a0,0xd
    8000534c:	0c2017b7          	lui	a5,0xc201
    80005350:	97aa                	add	a5,a5,a0
  return irq;
}
    80005352:	43c8                	lw	a0,4(a5)
    80005354:	60a2                	ld	ra,8(sp)
    80005356:	6402                	ld	s0,0(sp)
    80005358:	0141                	addi	sp,sp,16
    8000535a:	8082                	ret

000000008000535c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000535c:	1101                	addi	sp,sp,-32
    8000535e:	ec06                	sd	ra,24(sp)
    80005360:	e822                	sd	s0,16(sp)
    80005362:	e426                	sd	s1,8(sp)
    80005364:	1000                	addi	s0,sp,32
    80005366:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	baa080e7          	jalr	-1110(ra) # 80000f12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005370:	00d5151b          	slliw	a0,a0,0xd
    80005374:	0c2017b7          	lui	a5,0xc201
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	c3c4                	sw	s1,4(a5)
}
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	64a2                	ld	s1,8(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret

0000000080005386 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005386:	1141                	addi	sp,sp,-16
    80005388:	e406                	sd	ra,8(sp)
    8000538a:	e022                	sd	s0,0(sp)
    8000538c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000538e:	479d                	li	a5,7
    80005390:	04a7cc63          	blt	a5,a0,800053e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005394:	00015797          	auipc	a5,0x15
    80005398:	8ec78793          	addi	a5,a5,-1812 # 80019c80 <disk>
    8000539c:	97aa                	add	a5,a5,a0
    8000539e:	0187c783          	lbu	a5,24(a5)
    800053a2:	ebb9                	bnez	a5,800053f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053a4:	00451693          	slli	a3,a0,0x4
    800053a8:	00015797          	auipc	a5,0x15
    800053ac:	8d878793          	addi	a5,a5,-1832 # 80019c80 <disk>
    800053b0:	6398                	ld	a4,0(a5)
    800053b2:	9736                	add	a4,a4,a3
    800053b4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800053b8:	6398                	ld	a4,0(a5)
    800053ba:	9736                	add	a4,a4,a3
    800053bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053c8:	97aa                	add	a5,a5,a0
    800053ca:	4705                	li	a4,1
    800053cc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053d0:	00015517          	auipc	a0,0x15
    800053d4:	8c850513          	addi	a0,a0,-1848 # 80019c98 <disk+0x18>
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	2f4080e7          	jalr	756(ra) # 800016cc <wakeup>
}
    800053e0:	60a2                	ld	ra,8(sp)
    800053e2:	6402                	ld	s0,0(sp)
    800053e4:	0141                	addi	sp,sp,16
    800053e6:	8082                	ret
    panic("free_desc 1");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	37850513          	addi	a0,a0,888 # 80008760 <syscalls+0x360>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	a0c080e7          	jalr	-1524(ra) # 80005dfc <panic>
    panic("free_desc 2");
    800053f8:	00003517          	auipc	a0,0x3
    800053fc:	37850513          	addi	a0,a0,888 # 80008770 <syscalls+0x370>
    80005400:	00001097          	auipc	ra,0x1
    80005404:	9fc080e7          	jalr	-1540(ra) # 80005dfc <panic>

0000000080005408 <virtio_disk_init>:
{
    80005408:	1101                	addi	sp,sp,-32
    8000540a:	ec06                	sd	ra,24(sp)
    8000540c:	e822                	sd	s0,16(sp)
    8000540e:	e426                	sd	s1,8(sp)
    80005410:	e04a                	sd	s2,0(sp)
    80005412:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005414:	00003597          	auipc	a1,0x3
    80005418:	36c58593          	addi	a1,a1,876 # 80008780 <syscalls+0x380>
    8000541c:	00015517          	auipc	a0,0x15
    80005420:	98c50513          	addi	a0,a0,-1652 # 80019da8 <disk+0x128>
    80005424:	00001097          	auipc	ra,0x1
    80005428:	e80080e7          	jalr	-384(ra) # 800062a4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000542c:	100017b7          	lui	a5,0x10001
    80005430:	4398                	lw	a4,0(a5)
    80005432:	2701                	sext.w	a4,a4
    80005434:	747277b7          	lui	a5,0x74727
    80005438:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000543c:	14f71b63          	bne	a4,a5,80005592 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005440:	100017b7          	lui	a5,0x10001
    80005444:	43dc                	lw	a5,4(a5)
    80005446:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005448:	4709                	li	a4,2
    8000544a:	14e79463          	bne	a5,a4,80005592 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000544e:	100017b7          	lui	a5,0x10001
    80005452:	479c                	lw	a5,8(a5)
    80005454:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005456:	12e79e63          	bne	a5,a4,80005592 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000545a:	100017b7          	lui	a5,0x10001
    8000545e:	47d8                	lw	a4,12(a5)
    80005460:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005462:	554d47b7          	lui	a5,0x554d4
    80005466:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000546a:	12f71463          	bne	a4,a5,80005592 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000546e:	100017b7          	lui	a5,0x10001
    80005472:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005476:	4705                	li	a4,1
    80005478:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547a:	470d                	li	a4,3
    8000547c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000547e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005480:	c7ffe6b7          	lui	a3,0xc7ffe
    80005484:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc75f>
    80005488:	8f75                	and	a4,a4,a3
    8000548a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000548c:	472d                	li	a4,11
    8000548e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005490:	5bbc                	lw	a5,112(a5)
    80005492:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005496:	8ba1                	andi	a5,a5,8
    80005498:	10078563          	beqz	a5,800055a2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000549c:	100017b7          	lui	a5,0x10001
    800054a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054a4:	43fc                	lw	a5,68(a5)
    800054a6:	2781                	sext.w	a5,a5
    800054a8:	10079563          	bnez	a5,800055b2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054ac:	100017b7          	lui	a5,0x10001
    800054b0:	5bdc                	lw	a5,52(a5)
    800054b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054b4:	10078763          	beqz	a5,800055c2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800054b8:	471d                	li	a4,7
    800054ba:	10f77c63          	bgeu	a4,a5,800055d2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800054be:	ffffb097          	auipc	ra,0xffffb
    800054c2:	c5c080e7          	jalr	-932(ra) # 8000011a <kalloc>
    800054c6:	00014497          	auipc	s1,0x14
    800054ca:	7ba48493          	addi	s1,s1,1978 # 80019c80 <disk>
    800054ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054d0:	ffffb097          	auipc	ra,0xffffb
    800054d4:	c4a080e7          	jalr	-950(ra) # 8000011a <kalloc>
    800054d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054da:	ffffb097          	auipc	ra,0xffffb
    800054de:	c40080e7          	jalr	-960(ra) # 8000011a <kalloc>
    800054e2:	87aa                	mv	a5,a0
    800054e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054e6:	6088                	ld	a0,0(s1)
    800054e8:	cd6d                	beqz	a0,800055e2 <virtio_disk_init+0x1da>
    800054ea:	00014717          	auipc	a4,0x14
    800054ee:	79e73703          	ld	a4,1950(a4) # 80019c88 <disk+0x8>
    800054f2:	cb65                	beqz	a4,800055e2 <virtio_disk_init+0x1da>
    800054f4:	c7fd                	beqz	a5,800055e2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800054f6:	6605                	lui	a2,0x1
    800054f8:	4581                	li	a1,0
    800054fa:	ffffb097          	auipc	ra,0xffffb
    800054fe:	c80080e7          	jalr	-896(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005502:	00014497          	auipc	s1,0x14
    80005506:	77e48493          	addi	s1,s1,1918 # 80019c80 <disk>
    8000550a:	6605                	lui	a2,0x1
    8000550c:	4581                	li	a1,0
    8000550e:	6488                	ld	a0,8(s1)
    80005510:	ffffb097          	auipc	ra,0xffffb
    80005514:	c6a080e7          	jalr	-918(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005518:	6605                	lui	a2,0x1
    8000551a:	4581                	li	a1,0
    8000551c:	6888                	ld	a0,16(s1)
    8000551e:	ffffb097          	auipc	ra,0xffffb
    80005522:	c5c080e7          	jalr	-932(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005526:	100017b7          	lui	a5,0x10001
    8000552a:	4721                	li	a4,8
    8000552c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000552e:	4098                	lw	a4,0(s1)
    80005530:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005534:	40d8                	lw	a4,4(s1)
    80005536:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000553a:	6498                	ld	a4,8(s1)
    8000553c:	0007069b          	sext.w	a3,a4
    80005540:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005544:	9701                	srai	a4,a4,0x20
    80005546:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000554a:	6898                	ld	a4,16(s1)
    8000554c:	0007069b          	sext.w	a3,a4
    80005550:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005554:	9701                	srai	a4,a4,0x20
    80005556:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000555a:	4705                	li	a4,1
    8000555c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000555e:	00e48c23          	sb	a4,24(s1)
    80005562:	00e48ca3          	sb	a4,25(s1)
    80005566:	00e48d23          	sb	a4,26(s1)
    8000556a:	00e48da3          	sb	a4,27(s1)
    8000556e:	00e48e23          	sb	a4,28(s1)
    80005572:	00e48ea3          	sb	a4,29(s1)
    80005576:	00e48f23          	sb	a4,30(s1)
    8000557a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000557e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005582:	0727a823          	sw	s2,112(a5)
}
    80005586:	60e2                	ld	ra,24(sp)
    80005588:	6442                	ld	s0,16(sp)
    8000558a:	64a2                	ld	s1,8(sp)
    8000558c:	6902                	ld	s2,0(sp)
    8000558e:	6105                	addi	sp,sp,32
    80005590:	8082                	ret
    panic("could not find virtio disk");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	1fe50513          	addi	a0,a0,510 # 80008790 <syscalls+0x390>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	862080e7          	jalr	-1950(ra) # 80005dfc <panic>
    panic("virtio disk FEATURES_OK unset");
    800055a2:	00003517          	auipc	a0,0x3
    800055a6:	20e50513          	addi	a0,a0,526 # 800087b0 <syscalls+0x3b0>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	852080e7          	jalr	-1966(ra) # 80005dfc <panic>
    panic("virtio disk should not be ready");
    800055b2:	00003517          	auipc	a0,0x3
    800055b6:	21e50513          	addi	a0,a0,542 # 800087d0 <syscalls+0x3d0>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	842080e7          	jalr	-1982(ra) # 80005dfc <panic>
    panic("virtio disk has no queue 0");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	22e50513          	addi	a0,a0,558 # 800087f0 <syscalls+0x3f0>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	832080e7          	jalr	-1998(ra) # 80005dfc <panic>
    panic("virtio disk max queue too short");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	23e50513          	addi	a0,a0,574 # 80008810 <syscalls+0x410>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	822080e7          	jalr	-2014(ra) # 80005dfc <panic>
    panic("virtio disk kalloc");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	24e50513          	addi	a0,a0,590 # 80008830 <syscalls+0x430>
    800055ea:	00001097          	auipc	ra,0x1
    800055ee:	812080e7          	jalr	-2030(ra) # 80005dfc <panic>

00000000800055f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055f2:	7119                	addi	sp,sp,-128
    800055f4:	fc86                	sd	ra,120(sp)
    800055f6:	f8a2                	sd	s0,112(sp)
    800055f8:	f4a6                	sd	s1,104(sp)
    800055fa:	f0ca                	sd	s2,96(sp)
    800055fc:	ecce                	sd	s3,88(sp)
    800055fe:	e8d2                	sd	s4,80(sp)
    80005600:	e4d6                	sd	s5,72(sp)
    80005602:	e0da                	sd	s6,64(sp)
    80005604:	fc5e                	sd	s7,56(sp)
    80005606:	f862                	sd	s8,48(sp)
    80005608:	f466                	sd	s9,40(sp)
    8000560a:	f06a                	sd	s10,32(sp)
    8000560c:	ec6e                	sd	s11,24(sp)
    8000560e:	0100                	addi	s0,sp,128
    80005610:	8aaa                	mv	s5,a0
    80005612:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005614:	00c52d03          	lw	s10,12(a0)
    80005618:	001d1d1b          	slliw	s10,s10,0x1
    8000561c:	1d02                	slli	s10,s10,0x20
    8000561e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005622:	00014517          	auipc	a0,0x14
    80005626:	78650513          	addi	a0,a0,1926 # 80019da8 <disk+0x128>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	d0a080e7          	jalr	-758(ra) # 80006334 <acquire>
  for(int i = 0; i < 3; i++){
    80005632:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005634:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005636:	00014b97          	auipc	s7,0x14
    8000563a:	64ab8b93          	addi	s7,s7,1610 # 80019c80 <disk>
  for(int i = 0; i < 3; i++){
    8000563e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005640:	00014c97          	auipc	s9,0x14
    80005644:	768c8c93          	addi	s9,s9,1896 # 80019da8 <disk+0x128>
    80005648:	a08d                	j	800056aa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000564a:	00fb8733          	add	a4,s7,a5
    8000564e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005652:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005654:	0207c563          	bltz	a5,8000567e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005658:	2905                	addiw	s2,s2,1
    8000565a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000565c:	05690c63          	beq	s2,s6,800056b4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005660:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005662:	00014717          	auipc	a4,0x14
    80005666:	61e70713          	addi	a4,a4,1566 # 80019c80 <disk>
    8000566a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000566c:	01874683          	lbu	a3,24(a4)
    80005670:	fee9                	bnez	a3,8000564a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005672:	2785                	addiw	a5,a5,1
    80005674:	0705                	addi	a4,a4,1
    80005676:	fe979be3          	bne	a5,s1,8000566c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000567a:	57fd                	li	a5,-1
    8000567c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000567e:	01205d63          	blez	s2,80005698 <virtio_disk_rw+0xa6>
    80005682:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005684:	000a2503          	lw	a0,0(s4)
    80005688:	00000097          	auipc	ra,0x0
    8000568c:	cfe080e7          	jalr	-770(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    80005690:	2d85                	addiw	s11,s11,1
    80005692:	0a11                	addi	s4,s4,4
    80005694:	ff2d98e3          	bne	s11,s2,80005684 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005698:	85e6                	mv	a1,s9
    8000569a:	00014517          	auipc	a0,0x14
    8000569e:	5fe50513          	addi	a0,a0,1534 # 80019c98 <disk+0x18>
    800056a2:	ffffc097          	auipc	ra,0xffffc
    800056a6:	fc6080e7          	jalr	-58(ra) # 80001668 <sleep>
  for(int i = 0; i < 3; i++){
    800056aa:	f8040a13          	addi	s4,s0,-128
{
    800056ae:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800056b0:	894e                	mv	s2,s3
    800056b2:	b77d                	j	80005660 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056b4:	f8042503          	lw	a0,-128(s0)
    800056b8:	00a50713          	addi	a4,a0,10
    800056bc:	0712                	slli	a4,a4,0x4

  if(write)
    800056be:	00014797          	auipc	a5,0x14
    800056c2:	5c278793          	addi	a5,a5,1474 # 80019c80 <disk>
    800056c6:	00e786b3          	add	a3,a5,a4
    800056ca:	01803633          	snez	a2,s8
    800056ce:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056d0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800056d4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056d8:	f6070613          	addi	a2,a4,-160
    800056dc:	6394                	ld	a3,0(a5)
    800056de:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056e0:	00870593          	addi	a1,a4,8
    800056e4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056e6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056e8:	0007b803          	ld	a6,0(a5)
    800056ec:	9642                	add	a2,a2,a6
    800056ee:	46c1                	li	a3,16
    800056f0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056f2:	4585                	li	a1,1
    800056f4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800056f8:	f8442683          	lw	a3,-124(s0)
    800056fc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005700:	0692                	slli	a3,a3,0x4
    80005702:	9836                	add	a6,a6,a3
    80005704:	058a8613          	addi	a2,s5,88
    80005708:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000570c:	0007b803          	ld	a6,0(a5)
    80005710:	96c2                	add	a3,a3,a6
    80005712:	40000613          	li	a2,1024
    80005716:	c690                	sw	a2,8(a3)
  if(write)
    80005718:	001c3613          	seqz	a2,s8
    8000571c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005720:	00166613          	ori	a2,a2,1
    80005724:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005728:	f8842603          	lw	a2,-120(s0)
    8000572c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005730:	00250693          	addi	a3,a0,2
    80005734:	0692                	slli	a3,a3,0x4
    80005736:	96be                	add	a3,a3,a5
    80005738:	58fd                	li	a7,-1
    8000573a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000573e:	0612                	slli	a2,a2,0x4
    80005740:	9832                	add	a6,a6,a2
    80005742:	f9070713          	addi	a4,a4,-112
    80005746:	973e                	add	a4,a4,a5
    80005748:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000574c:	6398                	ld	a4,0(a5)
    8000574e:	9732                	add	a4,a4,a2
    80005750:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005752:	4609                	li	a2,2
    80005754:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005758:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000575c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005760:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005764:	6794                	ld	a3,8(a5)
    80005766:	0026d703          	lhu	a4,2(a3)
    8000576a:	8b1d                	andi	a4,a4,7
    8000576c:	0706                	slli	a4,a4,0x1
    8000576e:	96ba                	add	a3,a3,a4
    80005770:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005774:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005778:	6798                	ld	a4,8(a5)
    8000577a:	00275783          	lhu	a5,2(a4)
    8000577e:	2785                	addiw	a5,a5,1
    80005780:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005784:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005788:	100017b7          	lui	a5,0x10001
    8000578c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005790:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005794:	00014917          	auipc	s2,0x14
    80005798:	61490913          	addi	s2,s2,1556 # 80019da8 <disk+0x128>
  while(b->disk == 1) {
    8000579c:	4485                	li	s1,1
    8000579e:	00b79c63          	bne	a5,a1,800057b6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057a2:	85ca                	mv	a1,s2
    800057a4:	8556                	mv	a0,s5
    800057a6:	ffffc097          	auipc	ra,0xffffc
    800057aa:	ec2080e7          	jalr	-318(ra) # 80001668 <sleep>
  while(b->disk == 1) {
    800057ae:	004aa783          	lw	a5,4(s5)
    800057b2:	fe9788e3          	beq	a5,s1,800057a2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800057b6:	f8042903          	lw	s2,-128(s0)
    800057ba:	00290713          	addi	a4,s2,2
    800057be:	0712                	slli	a4,a4,0x4
    800057c0:	00014797          	auipc	a5,0x14
    800057c4:	4c078793          	addi	a5,a5,1216 # 80019c80 <disk>
    800057c8:	97ba                	add	a5,a5,a4
    800057ca:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ce:	00014997          	auipc	s3,0x14
    800057d2:	4b298993          	addi	s3,s3,1202 # 80019c80 <disk>
    800057d6:	00491713          	slli	a4,s2,0x4
    800057da:	0009b783          	ld	a5,0(s3)
    800057de:	97ba                	add	a5,a5,a4
    800057e0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057e4:	854a                	mv	a0,s2
    800057e6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057ea:	00000097          	auipc	ra,0x0
    800057ee:	b9c080e7          	jalr	-1124(ra) # 80005386 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057f2:	8885                	andi	s1,s1,1
    800057f4:	f0ed                	bnez	s1,800057d6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057f6:	00014517          	auipc	a0,0x14
    800057fa:	5b250513          	addi	a0,a0,1458 # 80019da8 <disk+0x128>
    800057fe:	00001097          	auipc	ra,0x1
    80005802:	bea080e7          	jalr	-1046(ra) # 800063e8 <release>
}
    80005806:	70e6                	ld	ra,120(sp)
    80005808:	7446                	ld	s0,112(sp)
    8000580a:	74a6                	ld	s1,104(sp)
    8000580c:	7906                	ld	s2,96(sp)
    8000580e:	69e6                	ld	s3,88(sp)
    80005810:	6a46                	ld	s4,80(sp)
    80005812:	6aa6                	ld	s5,72(sp)
    80005814:	6b06                	ld	s6,64(sp)
    80005816:	7be2                	ld	s7,56(sp)
    80005818:	7c42                	ld	s8,48(sp)
    8000581a:	7ca2                	ld	s9,40(sp)
    8000581c:	7d02                	ld	s10,32(sp)
    8000581e:	6de2                	ld	s11,24(sp)
    80005820:	6109                	addi	sp,sp,128
    80005822:	8082                	ret

0000000080005824 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005824:	1101                	addi	sp,sp,-32
    80005826:	ec06                	sd	ra,24(sp)
    80005828:	e822                	sd	s0,16(sp)
    8000582a:	e426                	sd	s1,8(sp)
    8000582c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000582e:	00014497          	auipc	s1,0x14
    80005832:	45248493          	addi	s1,s1,1106 # 80019c80 <disk>
    80005836:	00014517          	auipc	a0,0x14
    8000583a:	57250513          	addi	a0,a0,1394 # 80019da8 <disk+0x128>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	af6080e7          	jalr	-1290(ra) # 80006334 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005846:	10001737          	lui	a4,0x10001
    8000584a:	533c                	lw	a5,96(a4)
    8000584c:	8b8d                	andi	a5,a5,3
    8000584e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005850:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005854:	689c                	ld	a5,16(s1)
    80005856:	0204d703          	lhu	a4,32(s1)
    8000585a:	0027d783          	lhu	a5,2(a5)
    8000585e:	04f70863          	beq	a4,a5,800058ae <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005862:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005866:	6898                	ld	a4,16(s1)
    80005868:	0204d783          	lhu	a5,32(s1)
    8000586c:	8b9d                	andi	a5,a5,7
    8000586e:	078e                	slli	a5,a5,0x3
    80005870:	97ba                	add	a5,a5,a4
    80005872:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005874:	00278713          	addi	a4,a5,2
    80005878:	0712                	slli	a4,a4,0x4
    8000587a:	9726                	add	a4,a4,s1
    8000587c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005880:	e721                	bnez	a4,800058c8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005882:	0789                	addi	a5,a5,2
    80005884:	0792                	slli	a5,a5,0x4
    80005886:	97a6                	add	a5,a5,s1
    80005888:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000588a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000588e:	ffffc097          	auipc	ra,0xffffc
    80005892:	e3e080e7          	jalr	-450(ra) # 800016cc <wakeup>

    disk.used_idx += 1;
    80005896:	0204d783          	lhu	a5,32(s1)
    8000589a:	2785                	addiw	a5,a5,1
    8000589c:	17c2                	slli	a5,a5,0x30
    8000589e:	93c1                	srli	a5,a5,0x30
    800058a0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058a4:	6898                	ld	a4,16(s1)
    800058a6:	00275703          	lhu	a4,2(a4)
    800058aa:	faf71ce3          	bne	a4,a5,80005862 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058ae:	00014517          	auipc	a0,0x14
    800058b2:	4fa50513          	addi	a0,a0,1274 # 80019da8 <disk+0x128>
    800058b6:	00001097          	auipc	ra,0x1
    800058ba:	b32080e7          	jalr	-1230(ra) # 800063e8 <release>
}
    800058be:	60e2                	ld	ra,24(sp)
    800058c0:	6442                	ld	s0,16(sp)
    800058c2:	64a2                	ld	s1,8(sp)
    800058c4:	6105                	addi	sp,sp,32
    800058c6:	8082                	ret
      panic("virtio_disk_intr status");
    800058c8:	00003517          	auipc	a0,0x3
    800058cc:	f8050513          	addi	a0,a0,-128 # 80008848 <syscalls+0x448>
    800058d0:	00000097          	auipc	ra,0x0
    800058d4:	52c080e7          	jalr	1324(ra) # 80005dfc <panic>

00000000800058d8 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058d8:	1141                	addi	sp,sp,-16
    800058da:	e422                	sd	s0,8(sp)
    800058dc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058de:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058e2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058e6:	0037979b          	slliw	a5,a5,0x3
    800058ea:	02004737          	lui	a4,0x2004
    800058ee:	97ba                	add	a5,a5,a4
    800058f0:	0200c737          	lui	a4,0x200c
    800058f4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058f8:	000f4637          	lui	a2,0xf4
    800058fc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005900:	9732                	add	a4,a4,a2
    80005902:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005904:	00259693          	slli	a3,a1,0x2
    80005908:	96ae                	add	a3,a3,a1
    8000590a:	068e                	slli	a3,a3,0x3
    8000590c:	00014717          	auipc	a4,0x14
    80005910:	4b470713          	addi	a4,a4,1204 # 80019dc0 <timer_scratch>
    80005914:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005916:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005918:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000591a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000591e:	00000797          	auipc	a5,0x0
    80005922:	9a278793          	addi	a5,a5,-1630 # 800052c0 <timervec>
    80005926:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000592a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000592e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005932:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005936:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000593a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000593e:	30479073          	csrw	mie,a5
}
    80005942:	6422                	ld	s0,8(sp)
    80005944:	0141                	addi	sp,sp,16
    80005946:	8082                	ret

0000000080005948 <start>:
{
    80005948:	1141                	addi	sp,sp,-16
    8000594a:	e406                	sd	ra,8(sp)
    8000594c:	e022                	sd	s0,0(sp)
    8000594e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005950:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005954:	7779                	lui	a4,0xffffe
    80005956:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7ff>
    8000595a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000595c:	6705                	lui	a4,0x1
    8000595e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005962:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005964:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005968:	ffffb797          	auipc	a5,0xffffb
    8000596c:	9b878793          	addi	a5,a5,-1608 # 80000320 <main>
    80005970:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005974:	4781                	li	a5,0
    80005976:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000597a:	67c1                	lui	a5,0x10
    8000597c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000597e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005982:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005986:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000598a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000598e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005992:	57fd                	li	a5,-1
    80005994:	83a9                	srli	a5,a5,0xa
    80005996:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000599a:	47bd                	li	a5,15
    8000599c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	f38080e7          	jalr	-200(ra) # 800058d8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059a8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059ac:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059ae:	823e                	mv	tp,a5
  asm volatile("mret");
    800059b0:	30200073          	mret
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret

00000000800059bc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059bc:	715d                	addi	sp,sp,-80
    800059be:	e486                	sd	ra,72(sp)
    800059c0:	e0a2                	sd	s0,64(sp)
    800059c2:	fc26                	sd	s1,56(sp)
    800059c4:	f84a                	sd	s2,48(sp)
    800059c6:	f44e                	sd	s3,40(sp)
    800059c8:	f052                	sd	s4,32(sp)
    800059ca:	ec56                	sd	s5,24(sp)
    800059cc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059ce:	04c05763          	blez	a2,80005a1c <consolewrite+0x60>
    800059d2:	8a2a                	mv	s4,a0
    800059d4:	84ae                	mv	s1,a1
    800059d6:	89b2                	mv	s3,a2
    800059d8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059da:	5afd                	li	s5,-1
    800059dc:	4685                	li	a3,1
    800059de:	8626                	mv	a2,s1
    800059e0:	85d2                	mv	a1,s4
    800059e2:	fbf40513          	addi	a0,s0,-65
    800059e6:	ffffc097          	auipc	ra,0xffffc
    800059ea:	0e0080e7          	jalr	224(ra) # 80001ac6 <either_copyin>
    800059ee:	01550d63          	beq	a0,s5,80005a08 <consolewrite+0x4c>
      break;
    uartputc(c);
    800059f2:	fbf44503          	lbu	a0,-65(s0)
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	784080e7          	jalr	1924(ra) # 8000617a <uartputc>
  for(i = 0; i < n; i++){
    800059fe:	2905                	addiw	s2,s2,1
    80005a00:	0485                	addi	s1,s1,1
    80005a02:	fd299de3          	bne	s3,s2,800059dc <consolewrite+0x20>
    80005a06:	894e                	mv	s2,s3
  }

  return i;
}
    80005a08:	854a                	mv	a0,s2
    80005a0a:	60a6                	ld	ra,72(sp)
    80005a0c:	6406                	ld	s0,64(sp)
    80005a0e:	74e2                	ld	s1,56(sp)
    80005a10:	7942                	ld	s2,48(sp)
    80005a12:	79a2                	ld	s3,40(sp)
    80005a14:	7a02                	ld	s4,32(sp)
    80005a16:	6ae2                	ld	s5,24(sp)
    80005a18:	6161                	addi	sp,sp,80
    80005a1a:	8082                	ret
  for(i = 0; i < n; i++){
    80005a1c:	4901                	li	s2,0
    80005a1e:	b7ed                	j	80005a08 <consolewrite+0x4c>

0000000080005a20 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a20:	7159                	addi	sp,sp,-112
    80005a22:	f486                	sd	ra,104(sp)
    80005a24:	f0a2                	sd	s0,96(sp)
    80005a26:	eca6                	sd	s1,88(sp)
    80005a28:	e8ca                	sd	s2,80(sp)
    80005a2a:	e4ce                	sd	s3,72(sp)
    80005a2c:	e0d2                	sd	s4,64(sp)
    80005a2e:	fc56                	sd	s5,56(sp)
    80005a30:	f85a                	sd	s6,48(sp)
    80005a32:	f45e                	sd	s7,40(sp)
    80005a34:	f062                	sd	s8,32(sp)
    80005a36:	ec66                	sd	s9,24(sp)
    80005a38:	e86a                	sd	s10,16(sp)
    80005a3a:	1880                	addi	s0,sp,112
    80005a3c:	8aaa                	mv	s5,a0
    80005a3e:	8a2e                	mv	s4,a1
    80005a40:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a42:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a46:	0001c517          	auipc	a0,0x1c
    80005a4a:	4ba50513          	addi	a0,a0,1210 # 80021f00 <cons>
    80005a4e:	00001097          	auipc	ra,0x1
    80005a52:	8e6080e7          	jalr	-1818(ra) # 80006334 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a56:	0001c497          	auipc	s1,0x1c
    80005a5a:	4aa48493          	addi	s1,s1,1194 # 80021f00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a5e:	0001c917          	auipc	s2,0x1c
    80005a62:	53a90913          	addi	s2,s2,1338 # 80021f98 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005a66:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a68:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a6a:	4ca9                	li	s9,10
  while(n > 0){
    80005a6c:	07305b63          	blez	s3,80005ae2 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005a70:	0984a783          	lw	a5,152(s1)
    80005a74:	09c4a703          	lw	a4,156(s1)
    80005a78:	02f71763          	bne	a4,a5,80005aa6 <consoleread+0x86>
      if(killed(myproc())){
    80005a7c:	ffffb097          	auipc	ra,0xffffb
    80005a80:	4c2080e7          	jalr	1218(ra) # 80000f3e <myproc>
    80005a84:	ffffc097          	auipc	ra,0xffffc
    80005a88:	e8c080e7          	jalr	-372(ra) # 80001910 <killed>
    80005a8c:	e535                	bnez	a0,80005af8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005a8e:	85a6                	mv	a1,s1
    80005a90:	854a                	mv	a0,s2
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	bd6080e7          	jalr	-1066(ra) # 80001668 <sleep>
    while(cons.r == cons.w){
    80005a9a:	0984a783          	lw	a5,152(s1)
    80005a9e:	09c4a703          	lw	a4,156(s1)
    80005aa2:	fcf70de3          	beq	a4,a5,80005a7c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005aa6:	0017871b          	addiw	a4,a5,1
    80005aaa:	08e4ac23          	sw	a4,152(s1)
    80005aae:	07f7f713          	andi	a4,a5,127
    80005ab2:	9726                	add	a4,a4,s1
    80005ab4:	01874703          	lbu	a4,24(a4)
    80005ab8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005abc:	077d0563          	beq	s10,s7,80005b26 <consoleread+0x106>
    cbuf = c;
    80005ac0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ac4:	4685                	li	a3,1
    80005ac6:	f9f40613          	addi	a2,s0,-97
    80005aca:	85d2                	mv	a1,s4
    80005acc:	8556                	mv	a0,s5
    80005ace:	ffffc097          	auipc	ra,0xffffc
    80005ad2:	fa2080e7          	jalr	-94(ra) # 80001a70 <either_copyout>
    80005ad6:	01850663          	beq	a0,s8,80005ae2 <consoleread+0xc2>
    dst++;
    80005ada:	0a05                	addi	s4,s4,1
    --n;
    80005adc:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005ade:	f99d17e3          	bne	s10,s9,80005a6c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ae2:	0001c517          	auipc	a0,0x1c
    80005ae6:	41e50513          	addi	a0,a0,1054 # 80021f00 <cons>
    80005aea:	00001097          	auipc	ra,0x1
    80005aee:	8fe080e7          	jalr	-1794(ra) # 800063e8 <release>

  return target - n;
    80005af2:	413b053b          	subw	a0,s6,s3
    80005af6:	a811                	j	80005b0a <consoleread+0xea>
        release(&cons.lock);
    80005af8:	0001c517          	auipc	a0,0x1c
    80005afc:	40850513          	addi	a0,a0,1032 # 80021f00 <cons>
    80005b00:	00001097          	auipc	ra,0x1
    80005b04:	8e8080e7          	jalr	-1816(ra) # 800063e8 <release>
        return -1;
    80005b08:	557d                	li	a0,-1
}
    80005b0a:	70a6                	ld	ra,104(sp)
    80005b0c:	7406                	ld	s0,96(sp)
    80005b0e:	64e6                	ld	s1,88(sp)
    80005b10:	6946                	ld	s2,80(sp)
    80005b12:	69a6                	ld	s3,72(sp)
    80005b14:	6a06                	ld	s4,64(sp)
    80005b16:	7ae2                	ld	s5,56(sp)
    80005b18:	7b42                	ld	s6,48(sp)
    80005b1a:	7ba2                	ld	s7,40(sp)
    80005b1c:	7c02                	ld	s8,32(sp)
    80005b1e:	6ce2                	ld	s9,24(sp)
    80005b20:	6d42                	ld	s10,16(sp)
    80005b22:	6165                	addi	sp,sp,112
    80005b24:	8082                	ret
      if(n < target){
    80005b26:	0009871b          	sext.w	a4,s3
    80005b2a:	fb677ce3          	bgeu	a4,s6,80005ae2 <consoleread+0xc2>
        cons.r--;
    80005b2e:	0001c717          	auipc	a4,0x1c
    80005b32:	46f72523          	sw	a5,1130(a4) # 80021f98 <cons+0x98>
    80005b36:	b775                	j	80005ae2 <consoleread+0xc2>

0000000080005b38 <consputc>:
{
    80005b38:	1141                	addi	sp,sp,-16
    80005b3a:	e406                	sd	ra,8(sp)
    80005b3c:	e022                	sd	s0,0(sp)
    80005b3e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b40:	10000793          	li	a5,256
    80005b44:	00f50a63          	beq	a0,a5,80005b58 <consputc+0x20>
    uartputc_sync(c);
    80005b48:	00000097          	auipc	ra,0x0
    80005b4c:	560080e7          	jalr	1376(ra) # 800060a8 <uartputc_sync>
}
    80005b50:	60a2                	ld	ra,8(sp)
    80005b52:	6402                	ld	s0,0(sp)
    80005b54:	0141                	addi	sp,sp,16
    80005b56:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b58:	4521                	li	a0,8
    80005b5a:	00000097          	auipc	ra,0x0
    80005b5e:	54e080e7          	jalr	1358(ra) # 800060a8 <uartputc_sync>
    80005b62:	02000513          	li	a0,32
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	542080e7          	jalr	1346(ra) # 800060a8 <uartputc_sync>
    80005b6e:	4521                	li	a0,8
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	538080e7          	jalr	1336(ra) # 800060a8 <uartputc_sync>
    80005b78:	bfe1                	j	80005b50 <consputc+0x18>

0000000080005b7a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b7a:	1101                	addi	sp,sp,-32
    80005b7c:	ec06                	sd	ra,24(sp)
    80005b7e:	e822                	sd	s0,16(sp)
    80005b80:	e426                	sd	s1,8(sp)
    80005b82:	e04a                	sd	s2,0(sp)
    80005b84:	1000                	addi	s0,sp,32
    80005b86:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b88:	0001c517          	auipc	a0,0x1c
    80005b8c:	37850513          	addi	a0,a0,888 # 80021f00 <cons>
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	7a4080e7          	jalr	1956(ra) # 80006334 <acquire>

  switch(c){
    80005b98:	47d5                	li	a5,21
    80005b9a:	0af48663          	beq	s1,a5,80005c46 <consoleintr+0xcc>
    80005b9e:	0297ca63          	blt	a5,s1,80005bd2 <consoleintr+0x58>
    80005ba2:	47a1                	li	a5,8
    80005ba4:	0ef48763          	beq	s1,a5,80005c92 <consoleintr+0x118>
    80005ba8:	47c1                	li	a5,16
    80005baa:	10f49a63          	bne	s1,a5,80005cbe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bae:	ffffc097          	auipc	ra,0xffffc
    80005bb2:	f6e080e7          	jalr	-146(ra) # 80001b1c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bb6:	0001c517          	auipc	a0,0x1c
    80005bba:	34a50513          	addi	a0,a0,842 # 80021f00 <cons>
    80005bbe:	00001097          	auipc	ra,0x1
    80005bc2:	82a080e7          	jalr	-2006(ra) # 800063e8 <release>
}
    80005bc6:	60e2                	ld	ra,24(sp)
    80005bc8:	6442                	ld	s0,16(sp)
    80005bca:	64a2                	ld	s1,8(sp)
    80005bcc:	6902                	ld	s2,0(sp)
    80005bce:	6105                	addi	sp,sp,32
    80005bd0:	8082                	ret
  switch(c){
    80005bd2:	07f00793          	li	a5,127
    80005bd6:	0af48e63          	beq	s1,a5,80005c92 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bda:	0001c717          	auipc	a4,0x1c
    80005bde:	32670713          	addi	a4,a4,806 # 80021f00 <cons>
    80005be2:	0a072783          	lw	a5,160(a4)
    80005be6:	09872703          	lw	a4,152(a4)
    80005bea:	9f99                	subw	a5,a5,a4
    80005bec:	07f00713          	li	a4,127
    80005bf0:	fcf763e3          	bltu	a4,a5,80005bb6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bf4:	47b5                	li	a5,13
    80005bf6:	0cf48763          	beq	s1,a5,80005cc4 <consoleintr+0x14a>
      consputc(c);
    80005bfa:	8526                	mv	a0,s1
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	f3c080e7          	jalr	-196(ra) # 80005b38 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c04:	0001c797          	auipc	a5,0x1c
    80005c08:	2fc78793          	addi	a5,a5,764 # 80021f00 <cons>
    80005c0c:	0a07a683          	lw	a3,160(a5)
    80005c10:	0016871b          	addiw	a4,a3,1
    80005c14:	0007061b          	sext.w	a2,a4
    80005c18:	0ae7a023          	sw	a4,160(a5)
    80005c1c:	07f6f693          	andi	a3,a3,127
    80005c20:	97b6                	add	a5,a5,a3
    80005c22:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c26:	47a9                	li	a5,10
    80005c28:	0cf48563          	beq	s1,a5,80005cf2 <consoleintr+0x178>
    80005c2c:	4791                	li	a5,4
    80005c2e:	0cf48263          	beq	s1,a5,80005cf2 <consoleintr+0x178>
    80005c32:	0001c797          	auipc	a5,0x1c
    80005c36:	3667a783          	lw	a5,870(a5) # 80021f98 <cons+0x98>
    80005c3a:	9f1d                	subw	a4,a4,a5
    80005c3c:	08000793          	li	a5,128
    80005c40:	f6f71be3          	bne	a4,a5,80005bb6 <consoleintr+0x3c>
    80005c44:	a07d                	j	80005cf2 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c46:	0001c717          	auipc	a4,0x1c
    80005c4a:	2ba70713          	addi	a4,a4,698 # 80021f00 <cons>
    80005c4e:	0a072783          	lw	a5,160(a4)
    80005c52:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c56:	0001c497          	auipc	s1,0x1c
    80005c5a:	2aa48493          	addi	s1,s1,682 # 80021f00 <cons>
    while(cons.e != cons.w &&
    80005c5e:	4929                	li	s2,10
    80005c60:	f4f70be3          	beq	a4,a5,80005bb6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c64:	37fd                	addiw	a5,a5,-1
    80005c66:	07f7f713          	andi	a4,a5,127
    80005c6a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c6c:	01874703          	lbu	a4,24(a4)
    80005c70:	f52703e3          	beq	a4,s2,80005bb6 <consoleintr+0x3c>
      cons.e--;
    80005c74:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c78:	10000513          	li	a0,256
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	ebc080e7          	jalr	-324(ra) # 80005b38 <consputc>
    while(cons.e != cons.w &&
    80005c84:	0a04a783          	lw	a5,160(s1)
    80005c88:	09c4a703          	lw	a4,156(s1)
    80005c8c:	fcf71ce3          	bne	a4,a5,80005c64 <consoleintr+0xea>
    80005c90:	b71d                	j	80005bb6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c92:	0001c717          	auipc	a4,0x1c
    80005c96:	26e70713          	addi	a4,a4,622 # 80021f00 <cons>
    80005c9a:	0a072783          	lw	a5,160(a4)
    80005c9e:	09c72703          	lw	a4,156(a4)
    80005ca2:	f0f70ae3          	beq	a4,a5,80005bb6 <consoleintr+0x3c>
      cons.e--;
    80005ca6:	37fd                	addiw	a5,a5,-1
    80005ca8:	0001c717          	auipc	a4,0x1c
    80005cac:	2ef72c23          	sw	a5,760(a4) # 80021fa0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cb0:	10000513          	li	a0,256
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	e84080e7          	jalr	-380(ra) # 80005b38 <consputc>
    80005cbc:	bded                	j	80005bb6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005cbe:	ee048ce3          	beqz	s1,80005bb6 <consoleintr+0x3c>
    80005cc2:	bf21                	j	80005bda <consoleintr+0x60>
      consputc(c);
    80005cc4:	4529                	li	a0,10
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	e72080e7          	jalr	-398(ra) # 80005b38 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cce:	0001c797          	auipc	a5,0x1c
    80005cd2:	23278793          	addi	a5,a5,562 # 80021f00 <cons>
    80005cd6:	0a07a703          	lw	a4,160(a5)
    80005cda:	0017069b          	addiw	a3,a4,1
    80005cde:	0006861b          	sext.w	a2,a3
    80005ce2:	0ad7a023          	sw	a3,160(a5)
    80005ce6:	07f77713          	andi	a4,a4,127
    80005cea:	97ba                	add	a5,a5,a4
    80005cec:	4729                	li	a4,10
    80005cee:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cf2:	0001c797          	auipc	a5,0x1c
    80005cf6:	2ac7a523          	sw	a2,682(a5) # 80021f9c <cons+0x9c>
        wakeup(&cons.r);
    80005cfa:	0001c517          	auipc	a0,0x1c
    80005cfe:	29e50513          	addi	a0,a0,670 # 80021f98 <cons+0x98>
    80005d02:	ffffc097          	auipc	ra,0xffffc
    80005d06:	9ca080e7          	jalr	-1590(ra) # 800016cc <wakeup>
    80005d0a:	b575                	j	80005bb6 <consoleintr+0x3c>

0000000080005d0c <consoleinit>:

void
consoleinit(void)
{
    80005d0c:	1141                	addi	sp,sp,-16
    80005d0e:	e406                	sd	ra,8(sp)
    80005d10:	e022                	sd	s0,0(sp)
    80005d12:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d14:	00003597          	auipc	a1,0x3
    80005d18:	b4c58593          	addi	a1,a1,-1204 # 80008860 <syscalls+0x460>
    80005d1c:	0001c517          	auipc	a0,0x1c
    80005d20:	1e450513          	addi	a0,a0,484 # 80021f00 <cons>
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	580080e7          	jalr	1408(ra) # 800062a4 <initlock>

  uartinit();
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	32c080e7          	jalr	812(ra) # 80006058 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d34:	00013797          	auipc	a5,0x13
    80005d38:	ef478793          	addi	a5,a5,-268 # 80018c28 <devsw>
    80005d3c:	00000717          	auipc	a4,0x0
    80005d40:	ce470713          	addi	a4,a4,-796 # 80005a20 <consoleread>
    80005d44:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d46:	00000717          	auipc	a4,0x0
    80005d4a:	c7670713          	addi	a4,a4,-906 # 800059bc <consolewrite>
    80005d4e:	ef98                	sd	a4,24(a5)
}
    80005d50:	60a2                	ld	ra,8(sp)
    80005d52:	6402                	ld	s0,0(sp)
    80005d54:	0141                	addi	sp,sp,16
    80005d56:	8082                	ret

0000000080005d58 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d58:	7179                	addi	sp,sp,-48
    80005d5a:	f406                	sd	ra,40(sp)
    80005d5c:	f022                	sd	s0,32(sp)
    80005d5e:	ec26                	sd	s1,24(sp)
    80005d60:	e84a                	sd	s2,16(sp)
    80005d62:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d64:	c219                	beqz	a2,80005d6a <printint+0x12>
    80005d66:	08054763          	bltz	a0,80005df4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d6a:	2501                	sext.w	a0,a0
    80005d6c:	4881                	li	a7,0
    80005d6e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d72:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d74:	2581                	sext.w	a1,a1
    80005d76:	00003617          	auipc	a2,0x3
    80005d7a:	b1a60613          	addi	a2,a2,-1254 # 80008890 <digits>
    80005d7e:	883a                	mv	a6,a4
    80005d80:	2705                	addiw	a4,a4,1
    80005d82:	02b577bb          	remuw	a5,a0,a1
    80005d86:	1782                	slli	a5,a5,0x20
    80005d88:	9381                	srli	a5,a5,0x20
    80005d8a:	97b2                	add	a5,a5,a2
    80005d8c:	0007c783          	lbu	a5,0(a5)
    80005d90:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d94:	0005079b          	sext.w	a5,a0
    80005d98:	02b5553b          	divuw	a0,a0,a1
    80005d9c:	0685                	addi	a3,a3,1
    80005d9e:	feb7f0e3          	bgeu	a5,a1,80005d7e <printint+0x26>

  if(sign)
    80005da2:	00088c63          	beqz	a7,80005dba <printint+0x62>
    buf[i++] = '-';
    80005da6:	fe070793          	addi	a5,a4,-32
    80005daa:	00878733          	add	a4,a5,s0
    80005dae:	02d00793          	li	a5,45
    80005db2:	fef70823          	sb	a5,-16(a4)
    80005db6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005dba:	02e05763          	blez	a4,80005de8 <printint+0x90>
    80005dbe:	fd040793          	addi	a5,s0,-48
    80005dc2:	00e784b3          	add	s1,a5,a4
    80005dc6:	fff78913          	addi	s2,a5,-1
    80005dca:	993a                	add	s2,s2,a4
    80005dcc:	377d                	addiw	a4,a4,-1
    80005dce:	1702                	slli	a4,a4,0x20
    80005dd0:	9301                	srli	a4,a4,0x20
    80005dd2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dd6:	fff4c503          	lbu	a0,-1(s1)
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	d5e080e7          	jalr	-674(ra) # 80005b38 <consputc>
  while(--i >= 0)
    80005de2:	14fd                	addi	s1,s1,-1
    80005de4:	ff2499e3          	bne	s1,s2,80005dd6 <printint+0x7e>
}
    80005de8:	70a2                	ld	ra,40(sp)
    80005dea:	7402                	ld	s0,32(sp)
    80005dec:	64e2                	ld	s1,24(sp)
    80005dee:	6942                	ld	s2,16(sp)
    80005df0:	6145                	addi	sp,sp,48
    80005df2:	8082                	ret
    x = -xx;
    80005df4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005df8:	4885                	li	a7,1
    x = -xx;
    80005dfa:	bf95                	j	80005d6e <printint+0x16>

0000000080005dfc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dfc:	1101                	addi	sp,sp,-32
    80005dfe:	ec06                	sd	ra,24(sp)
    80005e00:	e822                	sd	s0,16(sp)
    80005e02:	e426                	sd	s1,8(sp)
    80005e04:	1000                	addi	s0,sp,32
    80005e06:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e08:	0001c797          	auipc	a5,0x1c
    80005e0c:	1a07ac23          	sw	zero,440(a5) # 80021fc0 <pr+0x18>
  printf("panic: ");
    80005e10:	00003517          	auipc	a0,0x3
    80005e14:	a5850513          	addi	a0,a0,-1448 # 80008868 <syscalls+0x468>
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	02e080e7          	jalr	46(ra) # 80005e46 <printf>
  printf(s);
    80005e20:	8526                	mv	a0,s1
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	024080e7          	jalr	36(ra) # 80005e46 <printf>
  printf("\n");
    80005e2a:	00002517          	auipc	a0,0x2
    80005e2e:	21e50513          	addi	a0,a0,542 # 80008048 <etext+0x48>
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	014080e7          	jalr	20(ra) # 80005e46 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e3a:	4785                	li	a5,1
    80005e3c:	00003717          	auipc	a4,0x3
    80005e40:	b2f72c23          	sw	a5,-1224(a4) # 80008974 <panicked>
  for(;;)
    80005e44:	a001                	j	80005e44 <panic+0x48>

0000000080005e46 <printf>:
{
    80005e46:	7131                	addi	sp,sp,-192
    80005e48:	fc86                	sd	ra,120(sp)
    80005e4a:	f8a2                	sd	s0,112(sp)
    80005e4c:	f4a6                	sd	s1,104(sp)
    80005e4e:	f0ca                	sd	s2,96(sp)
    80005e50:	ecce                	sd	s3,88(sp)
    80005e52:	e8d2                	sd	s4,80(sp)
    80005e54:	e4d6                	sd	s5,72(sp)
    80005e56:	e0da                	sd	s6,64(sp)
    80005e58:	fc5e                	sd	s7,56(sp)
    80005e5a:	f862                	sd	s8,48(sp)
    80005e5c:	f466                	sd	s9,40(sp)
    80005e5e:	f06a                	sd	s10,32(sp)
    80005e60:	ec6e                	sd	s11,24(sp)
    80005e62:	0100                	addi	s0,sp,128
    80005e64:	8a2a                	mv	s4,a0
    80005e66:	e40c                	sd	a1,8(s0)
    80005e68:	e810                	sd	a2,16(s0)
    80005e6a:	ec14                	sd	a3,24(s0)
    80005e6c:	f018                	sd	a4,32(s0)
    80005e6e:	f41c                	sd	a5,40(s0)
    80005e70:	03043823          	sd	a6,48(s0)
    80005e74:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e78:	0001cd97          	auipc	s11,0x1c
    80005e7c:	148dad83          	lw	s11,328(s11) # 80021fc0 <pr+0x18>
  if(locking)
    80005e80:	020d9b63          	bnez	s11,80005eb6 <printf+0x70>
  if (fmt == 0)
    80005e84:	040a0263          	beqz	s4,80005ec8 <printf+0x82>
  va_start(ap, fmt);
    80005e88:	00840793          	addi	a5,s0,8
    80005e8c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e90:	000a4503          	lbu	a0,0(s4)
    80005e94:	14050f63          	beqz	a0,80005ff2 <printf+0x1ac>
    80005e98:	4981                	li	s3,0
    if(c != '%'){
    80005e9a:	02500a93          	li	s5,37
    switch(c){
    80005e9e:	07000b93          	li	s7,112
  consputc('x');
    80005ea2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea4:	00003b17          	auipc	s6,0x3
    80005ea8:	9ecb0b13          	addi	s6,s6,-1556 # 80008890 <digits>
    switch(c){
    80005eac:	07300c93          	li	s9,115
    80005eb0:	06400c13          	li	s8,100
    80005eb4:	a82d                	j	80005eee <printf+0xa8>
    acquire(&pr.lock);
    80005eb6:	0001c517          	auipc	a0,0x1c
    80005eba:	0f250513          	addi	a0,a0,242 # 80021fa8 <pr>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	476080e7          	jalr	1142(ra) # 80006334 <acquire>
    80005ec6:	bf7d                	j	80005e84 <printf+0x3e>
    panic("null fmt");
    80005ec8:	00003517          	auipc	a0,0x3
    80005ecc:	9b050513          	addi	a0,a0,-1616 # 80008878 <syscalls+0x478>
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	f2c080e7          	jalr	-212(ra) # 80005dfc <panic>
      consputc(c);
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	c60080e7          	jalr	-928(ra) # 80005b38 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ee0:	2985                	addiw	s3,s3,1
    80005ee2:	013a07b3          	add	a5,s4,s3
    80005ee6:	0007c503          	lbu	a0,0(a5)
    80005eea:	10050463          	beqz	a0,80005ff2 <printf+0x1ac>
    if(c != '%'){
    80005eee:	ff5515e3          	bne	a0,s5,80005ed8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ef2:	2985                	addiw	s3,s3,1
    80005ef4:	013a07b3          	add	a5,s4,s3
    80005ef8:	0007c783          	lbu	a5,0(a5)
    80005efc:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f00:	cbed                	beqz	a5,80005ff2 <printf+0x1ac>
    switch(c){
    80005f02:	05778a63          	beq	a5,s7,80005f56 <printf+0x110>
    80005f06:	02fbf663          	bgeu	s7,a5,80005f32 <printf+0xec>
    80005f0a:	09978863          	beq	a5,s9,80005f9a <printf+0x154>
    80005f0e:	07800713          	li	a4,120
    80005f12:	0ce79563          	bne	a5,a4,80005fdc <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f16:	f8843783          	ld	a5,-120(s0)
    80005f1a:	00878713          	addi	a4,a5,8
    80005f1e:	f8e43423          	sd	a4,-120(s0)
    80005f22:	4605                	li	a2,1
    80005f24:	85ea                	mv	a1,s10
    80005f26:	4388                	lw	a0,0(a5)
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	e30080e7          	jalr	-464(ra) # 80005d58 <printint>
      break;
    80005f30:	bf45                	j	80005ee0 <printf+0x9a>
    switch(c){
    80005f32:	09578f63          	beq	a5,s5,80005fd0 <printf+0x18a>
    80005f36:	0b879363          	bne	a5,s8,80005fdc <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f3a:	f8843783          	ld	a5,-120(s0)
    80005f3e:	00878713          	addi	a4,a5,8
    80005f42:	f8e43423          	sd	a4,-120(s0)
    80005f46:	4605                	li	a2,1
    80005f48:	45a9                	li	a1,10
    80005f4a:	4388                	lw	a0,0(a5)
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	e0c080e7          	jalr	-500(ra) # 80005d58 <printint>
      break;
    80005f54:	b771                	j	80005ee0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f56:	f8843783          	ld	a5,-120(s0)
    80005f5a:	00878713          	addi	a4,a5,8
    80005f5e:	f8e43423          	sd	a4,-120(s0)
    80005f62:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f66:	03000513          	li	a0,48
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	bce080e7          	jalr	-1074(ra) # 80005b38 <consputc>
  consputc('x');
    80005f72:	07800513          	li	a0,120
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	bc2080e7          	jalr	-1086(ra) # 80005b38 <consputc>
    80005f7e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f80:	03c95793          	srli	a5,s2,0x3c
    80005f84:	97da                	add	a5,a5,s6
    80005f86:	0007c503          	lbu	a0,0(a5)
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	bae080e7          	jalr	-1106(ra) # 80005b38 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f92:	0912                	slli	s2,s2,0x4
    80005f94:	34fd                	addiw	s1,s1,-1
    80005f96:	f4ed                	bnez	s1,80005f80 <printf+0x13a>
    80005f98:	b7a1                	j	80005ee0 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f9a:	f8843783          	ld	a5,-120(s0)
    80005f9e:	00878713          	addi	a4,a5,8
    80005fa2:	f8e43423          	sd	a4,-120(s0)
    80005fa6:	6384                	ld	s1,0(a5)
    80005fa8:	cc89                	beqz	s1,80005fc2 <printf+0x17c>
      for(; *s; s++)
    80005faa:	0004c503          	lbu	a0,0(s1)
    80005fae:	d90d                	beqz	a0,80005ee0 <printf+0x9a>
        consputc(*s);
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b88080e7          	jalr	-1144(ra) # 80005b38 <consputc>
      for(; *s; s++)
    80005fb8:	0485                	addi	s1,s1,1
    80005fba:	0004c503          	lbu	a0,0(s1)
    80005fbe:	f96d                	bnez	a0,80005fb0 <printf+0x16a>
    80005fc0:	b705                	j	80005ee0 <printf+0x9a>
        s = "(null)";
    80005fc2:	00003497          	auipc	s1,0x3
    80005fc6:	8ae48493          	addi	s1,s1,-1874 # 80008870 <syscalls+0x470>
      for(; *s; s++)
    80005fca:	02800513          	li	a0,40
    80005fce:	b7cd                	j	80005fb0 <printf+0x16a>
      consputc('%');
    80005fd0:	8556                	mv	a0,s5
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	b66080e7          	jalr	-1178(ra) # 80005b38 <consputc>
      break;
    80005fda:	b719                	j	80005ee0 <printf+0x9a>
      consputc('%');
    80005fdc:	8556                	mv	a0,s5
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	b5a080e7          	jalr	-1190(ra) # 80005b38 <consputc>
      consputc(c);
    80005fe6:	8526                	mv	a0,s1
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	b50080e7          	jalr	-1200(ra) # 80005b38 <consputc>
      break;
    80005ff0:	bdc5                	j	80005ee0 <printf+0x9a>
  if(locking)
    80005ff2:	020d9163          	bnez	s11,80006014 <printf+0x1ce>
}
    80005ff6:	70e6                	ld	ra,120(sp)
    80005ff8:	7446                	ld	s0,112(sp)
    80005ffa:	74a6                	ld	s1,104(sp)
    80005ffc:	7906                	ld	s2,96(sp)
    80005ffe:	69e6                	ld	s3,88(sp)
    80006000:	6a46                	ld	s4,80(sp)
    80006002:	6aa6                	ld	s5,72(sp)
    80006004:	6b06                	ld	s6,64(sp)
    80006006:	7be2                	ld	s7,56(sp)
    80006008:	7c42                	ld	s8,48(sp)
    8000600a:	7ca2                	ld	s9,40(sp)
    8000600c:	7d02                	ld	s10,32(sp)
    8000600e:	6de2                	ld	s11,24(sp)
    80006010:	6129                	addi	sp,sp,192
    80006012:	8082                	ret
    release(&pr.lock);
    80006014:	0001c517          	auipc	a0,0x1c
    80006018:	f9450513          	addi	a0,a0,-108 # 80021fa8 <pr>
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	3cc080e7          	jalr	972(ra) # 800063e8 <release>
}
    80006024:	bfc9                	j	80005ff6 <printf+0x1b0>

0000000080006026 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006026:	1101                	addi	sp,sp,-32
    80006028:	ec06                	sd	ra,24(sp)
    8000602a:	e822                	sd	s0,16(sp)
    8000602c:	e426                	sd	s1,8(sp)
    8000602e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006030:	0001c497          	auipc	s1,0x1c
    80006034:	f7848493          	addi	s1,s1,-136 # 80021fa8 <pr>
    80006038:	00003597          	auipc	a1,0x3
    8000603c:	85058593          	addi	a1,a1,-1968 # 80008888 <syscalls+0x488>
    80006040:	8526                	mv	a0,s1
    80006042:	00000097          	auipc	ra,0x0
    80006046:	262080e7          	jalr	610(ra) # 800062a4 <initlock>
  pr.locking = 1;
    8000604a:	4785                	li	a5,1
    8000604c:	cc9c                	sw	a5,24(s1)
}
    8000604e:	60e2                	ld	ra,24(sp)
    80006050:	6442                	ld	s0,16(sp)
    80006052:	64a2                	ld	s1,8(sp)
    80006054:	6105                	addi	sp,sp,32
    80006056:	8082                	ret

0000000080006058 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006058:	1141                	addi	sp,sp,-16
    8000605a:	e406                	sd	ra,8(sp)
    8000605c:	e022                	sd	s0,0(sp)
    8000605e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006060:	100007b7          	lui	a5,0x10000
    80006064:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006068:	f8000713          	li	a4,-128
    8000606c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006070:	470d                	li	a4,3
    80006072:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006076:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000607a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000607e:	469d                	li	a3,7
    80006080:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006084:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006088:	00003597          	auipc	a1,0x3
    8000608c:	82058593          	addi	a1,a1,-2016 # 800088a8 <digits+0x18>
    80006090:	0001c517          	auipc	a0,0x1c
    80006094:	f3850513          	addi	a0,a0,-200 # 80021fc8 <uart_tx_lock>
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	20c080e7          	jalr	524(ra) # 800062a4 <initlock>
}
    800060a0:	60a2                	ld	ra,8(sp)
    800060a2:	6402                	ld	s0,0(sp)
    800060a4:	0141                	addi	sp,sp,16
    800060a6:	8082                	ret

00000000800060a8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060a8:	1101                	addi	sp,sp,-32
    800060aa:	ec06                	sd	ra,24(sp)
    800060ac:	e822                	sd	s0,16(sp)
    800060ae:	e426                	sd	s1,8(sp)
    800060b0:	1000                	addi	s0,sp,32
    800060b2:	84aa                	mv	s1,a0
  push_off();
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	234080e7          	jalr	564(ra) # 800062e8 <push_off>

  if(panicked){
    800060bc:	00003797          	auipc	a5,0x3
    800060c0:	8b87a783          	lw	a5,-1864(a5) # 80008974 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060c4:	10000737          	lui	a4,0x10000
  if(panicked){
    800060c8:	c391                	beqz	a5,800060cc <uartputc_sync+0x24>
    for(;;)
    800060ca:	a001                	j	800060ca <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060cc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060d0:	0207f793          	andi	a5,a5,32
    800060d4:	dfe5                	beqz	a5,800060cc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060d6:	0ff4f513          	zext.b	a0,s1
    800060da:	100007b7          	lui	a5,0x10000
    800060de:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	2a6080e7          	jalr	678(ra) # 80006388 <pop_off>
}
    800060ea:	60e2                	ld	ra,24(sp)
    800060ec:	6442                	ld	s0,16(sp)
    800060ee:	64a2                	ld	s1,8(sp)
    800060f0:	6105                	addi	sp,sp,32
    800060f2:	8082                	ret

00000000800060f4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060f4:	00003797          	auipc	a5,0x3
    800060f8:	8847b783          	ld	a5,-1916(a5) # 80008978 <uart_tx_r>
    800060fc:	00003717          	auipc	a4,0x3
    80006100:	88473703          	ld	a4,-1916(a4) # 80008980 <uart_tx_w>
    80006104:	06f70a63          	beq	a4,a5,80006178 <uartstart+0x84>
{
    80006108:	7139                	addi	sp,sp,-64
    8000610a:	fc06                	sd	ra,56(sp)
    8000610c:	f822                	sd	s0,48(sp)
    8000610e:	f426                	sd	s1,40(sp)
    80006110:	f04a                	sd	s2,32(sp)
    80006112:	ec4e                	sd	s3,24(sp)
    80006114:	e852                	sd	s4,16(sp)
    80006116:	e456                	sd	s5,8(sp)
    80006118:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000611a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611e:	0001ca17          	auipc	s4,0x1c
    80006122:	eaaa0a13          	addi	s4,s4,-342 # 80021fc8 <uart_tx_lock>
    uart_tx_r += 1;
    80006126:	00003497          	auipc	s1,0x3
    8000612a:	85248493          	addi	s1,s1,-1966 # 80008978 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000612e:	00003997          	auipc	s3,0x3
    80006132:	85298993          	addi	s3,s3,-1966 # 80008980 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006136:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000613a:	02077713          	andi	a4,a4,32
    8000613e:	c705                	beqz	a4,80006166 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006140:	01f7f713          	andi	a4,a5,31
    80006144:	9752                	add	a4,a4,s4
    80006146:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000614a:	0785                	addi	a5,a5,1
    8000614c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000614e:	8526                	mv	a0,s1
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	57c080e7          	jalr	1404(ra) # 800016cc <wakeup>
    
    WriteReg(THR, c);
    80006158:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000615c:	609c                	ld	a5,0(s1)
    8000615e:	0009b703          	ld	a4,0(s3)
    80006162:	fcf71ae3          	bne	a4,a5,80006136 <uartstart+0x42>
  }
}
    80006166:	70e2                	ld	ra,56(sp)
    80006168:	7442                	ld	s0,48(sp)
    8000616a:	74a2                	ld	s1,40(sp)
    8000616c:	7902                	ld	s2,32(sp)
    8000616e:	69e2                	ld	s3,24(sp)
    80006170:	6a42                	ld	s4,16(sp)
    80006172:	6aa2                	ld	s5,8(sp)
    80006174:	6121                	addi	sp,sp,64
    80006176:	8082                	ret
    80006178:	8082                	ret

000000008000617a <uartputc>:
{
    8000617a:	7179                	addi	sp,sp,-48
    8000617c:	f406                	sd	ra,40(sp)
    8000617e:	f022                	sd	s0,32(sp)
    80006180:	ec26                	sd	s1,24(sp)
    80006182:	e84a                	sd	s2,16(sp)
    80006184:	e44e                	sd	s3,8(sp)
    80006186:	e052                	sd	s4,0(sp)
    80006188:	1800                	addi	s0,sp,48
    8000618a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000618c:	0001c517          	auipc	a0,0x1c
    80006190:	e3c50513          	addi	a0,a0,-452 # 80021fc8 <uart_tx_lock>
    80006194:	00000097          	auipc	ra,0x0
    80006198:	1a0080e7          	jalr	416(ra) # 80006334 <acquire>
  if(panicked){
    8000619c:	00002797          	auipc	a5,0x2
    800061a0:	7d87a783          	lw	a5,2008(a5) # 80008974 <panicked>
    800061a4:	e7c9                	bnez	a5,8000622e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a6:	00002717          	auipc	a4,0x2
    800061aa:	7da73703          	ld	a4,2010(a4) # 80008980 <uart_tx_w>
    800061ae:	00002797          	auipc	a5,0x2
    800061b2:	7ca7b783          	ld	a5,1994(a5) # 80008978 <uart_tx_r>
    800061b6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800061ba:	0001c997          	auipc	s3,0x1c
    800061be:	e0e98993          	addi	s3,s3,-498 # 80021fc8 <uart_tx_lock>
    800061c2:	00002497          	auipc	s1,0x2
    800061c6:	7b648493          	addi	s1,s1,1974 # 80008978 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ca:	00002917          	auipc	s2,0x2
    800061ce:	7b690913          	addi	s2,s2,1974 # 80008980 <uart_tx_w>
    800061d2:	00e79f63          	bne	a5,a4,800061f0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800061d6:	85ce                	mv	a1,s3
    800061d8:	8526                	mv	a0,s1
    800061da:	ffffb097          	auipc	ra,0xffffb
    800061de:	48e080e7          	jalr	1166(ra) # 80001668 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e2:	00093703          	ld	a4,0(s2)
    800061e6:	609c                	ld	a5,0(s1)
    800061e8:	02078793          	addi	a5,a5,32
    800061ec:	fee785e3          	beq	a5,a4,800061d6 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061f0:	0001c497          	auipc	s1,0x1c
    800061f4:	dd848493          	addi	s1,s1,-552 # 80021fc8 <uart_tx_lock>
    800061f8:	01f77793          	andi	a5,a4,31
    800061fc:	97a6                	add	a5,a5,s1
    800061fe:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006202:	0705                	addi	a4,a4,1
    80006204:	00002797          	auipc	a5,0x2
    80006208:	76e7be23          	sd	a4,1916(a5) # 80008980 <uart_tx_w>
  uartstart();
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	ee8080e7          	jalr	-280(ra) # 800060f4 <uartstart>
  release(&uart_tx_lock);
    80006214:	8526                	mv	a0,s1
    80006216:	00000097          	auipc	ra,0x0
    8000621a:	1d2080e7          	jalr	466(ra) # 800063e8 <release>
}
    8000621e:	70a2                	ld	ra,40(sp)
    80006220:	7402                	ld	s0,32(sp)
    80006222:	64e2                	ld	s1,24(sp)
    80006224:	6942                	ld	s2,16(sp)
    80006226:	69a2                	ld	s3,8(sp)
    80006228:	6a02                	ld	s4,0(sp)
    8000622a:	6145                	addi	sp,sp,48
    8000622c:	8082                	ret
    for(;;)
    8000622e:	a001                	j	8000622e <uartputc+0xb4>

0000000080006230 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006230:	1141                	addi	sp,sp,-16
    80006232:	e422                	sd	s0,8(sp)
    80006234:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006236:	100007b7          	lui	a5,0x10000
    8000623a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000623e:	8b85                	andi	a5,a5,1
    80006240:	cb81                	beqz	a5,80006250 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006242:	100007b7          	lui	a5,0x10000
    80006246:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000624a:	6422                	ld	s0,8(sp)
    8000624c:	0141                	addi	sp,sp,16
    8000624e:	8082                	ret
    return -1;
    80006250:	557d                	li	a0,-1
    80006252:	bfe5                	j	8000624a <uartgetc+0x1a>

0000000080006254 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006254:	1101                	addi	sp,sp,-32
    80006256:	ec06                	sd	ra,24(sp)
    80006258:	e822                	sd	s0,16(sp)
    8000625a:	e426                	sd	s1,8(sp)
    8000625c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000625e:	54fd                	li	s1,-1
    80006260:	a029                	j	8000626a <uartintr+0x16>
      break;
    consoleintr(c);
    80006262:	00000097          	auipc	ra,0x0
    80006266:	918080e7          	jalr	-1768(ra) # 80005b7a <consoleintr>
    int c = uartgetc();
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	fc6080e7          	jalr	-58(ra) # 80006230 <uartgetc>
    if(c == -1)
    80006272:	fe9518e3          	bne	a0,s1,80006262 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006276:	0001c497          	auipc	s1,0x1c
    8000627a:	d5248493          	addi	s1,s1,-686 # 80021fc8 <uart_tx_lock>
    8000627e:	8526                	mv	a0,s1
    80006280:	00000097          	auipc	ra,0x0
    80006284:	0b4080e7          	jalr	180(ra) # 80006334 <acquire>
  uartstart();
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	e6c080e7          	jalr	-404(ra) # 800060f4 <uartstart>
  release(&uart_tx_lock);
    80006290:	8526                	mv	a0,s1
    80006292:	00000097          	auipc	ra,0x0
    80006296:	156080e7          	jalr	342(ra) # 800063e8 <release>
}
    8000629a:	60e2                	ld	ra,24(sp)
    8000629c:	6442                	ld	s0,16(sp)
    8000629e:	64a2                	ld	s1,8(sp)
    800062a0:	6105                	addi	sp,sp,32
    800062a2:	8082                	ret

00000000800062a4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062a4:	1141                	addi	sp,sp,-16
    800062a6:	e422                	sd	s0,8(sp)
    800062a8:	0800                	addi	s0,sp,16
  lk->name = name;
    800062aa:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062ac:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062b0:	00053823          	sd	zero,16(a0)
}
    800062b4:	6422                	ld	s0,8(sp)
    800062b6:	0141                	addi	sp,sp,16
    800062b8:	8082                	ret

00000000800062ba <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062ba:	411c                	lw	a5,0(a0)
    800062bc:	e399                	bnez	a5,800062c2 <holding+0x8>
    800062be:	4501                	li	a0,0
  return r;
}
    800062c0:	8082                	ret
{
    800062c2:	1101                	addi	sp,sp,-32
    800062c4:	ec06                	sd	ra,24(sp)
    800062c6:	e822                	sd	s0,16(sp)
    800062c8:	e426                	sd	s1,8(sp)
    800062ca:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062cc:	6904                	ld	s1,16(a0)
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	c54080e7          	jalr	-940(ra) # 80000f22 <mycpu>
    800062d6:	40a48533          	sub	a0,s1,a0
    800062da:	00153513          	seqz	a0,a0
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret

00000000800062e8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062e8:	1101                	addi	sp,sp,-32
    800062ea:	ec06                	sd	ra,24(sp)
    800062ec:	e822                	sd	s0,16(sp)
    800062ee:	e426                	sd	s1,8(sp)
    800062f0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f2:	100024f3          	csrr	s1,sstatus
    800062f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062fa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062fc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006300:	ffffb097          	auipc	ra,0xffffb
    80006304:	c22080e7          	jalr	-990(ra) # 80000f22 <mycpu>
    80006308:	5d3c                	lw	a5,120(a0)
    8000630a:	cf89                	beqz	a5,80006324 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000630c:	ffffb097          	auipc	ra,0xffffb
    80006310:	c16080e7          	jalr	-1002(ra) # 80000f22 <mycpu>
    80006314:	5d3c                	lw	a5,120(a0)
    80006316:	2785                	addiw	a5,a5,1
    80006318:	dd3c                	sw	a5,120(a0)
}
    8000631a:	60e2                	ld	ra,24(sp)
    8000631c:	6442                	ld	s0,16(sp)
    8000631e:	64a2                	ld	s1,8(sp)
    80006320:	6105                	addi	sp,sp,32
    80006322:	8082                	ret
    mycpu()->intena = old;
    80006324:	ffffb097          	auipc	ra,0xffffb
    80006328:	bfe080e7          	jalr	-1026(ra) # 80000f22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000632c:	8085                	srli	s1,s1,0x1
    8000632e:	8885                	andi	s1,s1,1
    80006330:	dd64                	sw	s1,124(a0)
    80006332:	bfe9                	j	8000630c <push_off+0x24>

0000000080006334 <acquire>:
{
    80006334:	1101                	addi	sp,sp,-32
    80006336:	ec06                	sd	ra,24(sp)
    80006338:	e822                	sd	s0,16(sp)
    8000633a:	e426                	sd	s1,8(sp)
    8000633c:	1000                	addi	s0,sp,32
    8000633e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006340:	00000097          	auipc	ra,0x0
    80006344:	fa8080e7          	jalr	-88(ra) # 800062e8 <push_off>
  if(holding(lk))
    80006348:	8526                	mv	a0,s1
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	f70080e7          	jalr	-144(ra) # 800062ba <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006352:	4705                	li	a4,1
  if(holding(lk))
    80006354:	e115                	bnez	a0,80006378 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006356:	87ba                	mv	a5,a4
    80006358:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000635c:	2781                	sext.w	a5,a5
    8000635e:	ffe5                	bnez	a5,80006356 <acquire+0x22>
  __sync_synchronize();
    80006360:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006364:	ffffb097          	auipc	ra,0xffffb
    80006368:	bbe080e7          	jalr	-1090(ra) # 80000f22 <mycpu>
    8000636c:	e888                	sd	a0,16(s1)
}
    8000636e:	60e2                	ld	ra,24(sp)
    80006370:	6442                	ld	s0,16(sp)
    80006372:	64a2                	ld	s1,8(sp)
    80006374:	6105                	addi	sp,sp,32
    80006376:	8082                	ret
    panic("acquire");
    80006378:	00002517          	auipc	a0,0x2
    8000637c:	53850513          	addi	a0,a0,1336 # 800088b0 <digits+0x20>
    80006380:	00000097          	auipc	ra,0x0
    80006384:	a7c080e7          	jalr	-1412(ra) # 80005dfc <panic>

0000000080006388 <pop_off>:

void
pop_off(void)
{
    80006388:	1141                	addi	sp,sp,-16
    8000638a:	e406                	sd	ra,8(sp)
    8000638c:	e022                	sd	s0,0(sp)
    8000638e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	b92080e7          	jalr	-1134(ra) # 80000f22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006398:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000639c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000639e:	e78d                	bnez	a5,800063c8 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063a0:	5d3c                	lw	a5,120(a0)
    800063a2:	02f05b63          	blez	a5,800063d8 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063a6:	37fd                	addiw	a5,a5,-1
    800063a8:	0007871b          	sext.w	a4,a5
    800063ac:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063ae:	eb09                	bnez	a4,800063c0 <pop_off+0x38>
    800063b0:	5d7c                	lw	a5,124(a0)
    800063b2:	c799                	beqz	a5,800063c0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063bc:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063c0:	60a2                	ld	ra,8(sp)
    800063c2:	6402                	ld	s0,0(sp)
    800063c4:	0141                	addi	sp,sp,16
    800063c6:	8082                	ret
    panic("pop_off - interruptible");
    800063c8:	00002517          	auipc	a0,0x2
    800063cc:	4f050513          	addi	a0,a0,1264 # 800088b8 <digits+0x28>
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	a2c080e7          	jalr	-1492(ra) # 80005dfc <panic>
    panic("pop_off");
    800063d8:	00002517          	auipc	a0,0x2
    800063dc:	4f850513          	addi	a0,a0,1272 # 800088d0 <digits+0x40>
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	a1c080e7          	jalr	-1508(ra) # 80005dfc <panic>

00000000800063e8 <release>:
{
    800063e8:	1101                	addi	sp,sp,-32
    800063ea:	ec06                	sd	ra,24(sp)
    800063ec:	e822                	sd	s0,16(sp)
    800063ee:	e426                	sd	s1,8(sp)
    800063f0:	1000                	addi	s0,sp,32
    800063f2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063f4:	00000097          	auipc	ra,0x0
    800063f8:	ec6080e7          	jalr	-314(ra) # 800062ba <holding>
    800063fc:	c115                	beqz	a0,80006420 <release+0x38>
  lk->cpu = 0;
    800063fe:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006402:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006406:	0f50000f          	fence	iorw,ow
    8000640a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000640e:	00000097          	auipc	ra,0x0
    80006412:	f7a080e7          	jalr	-134(ra) # 80006388 <pop_off>
}
    80006416:	60e2                	ld	ra,24(sp)
    80006418:	6442                	ld	s0,16(sp)
    8000641a:	64a2                	ld	s1,8(sp)
    8000641c:	6105                	addi	sp,sp,32
    8000641e:	8082                	ret
    panic("release");
    80006420:	00002517          	auipc	a0,0x2
    80006424:	4b850513          	addi	a0,a0,1208 # 800088d8 <digits+0x48>
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	9d4080e7          	jalr	-1580(ra) # 80005dfc <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
