
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8c013103          	ld	sp,-1856(sp) # 800088c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	033050ef          	jal	ra,80005848 <start>

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
    80000030:	00027797          	auipc	a5,0x27
    80000034:	d5078793          	addi	a5,a5,-688 # 80026d80 <end>
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
    80000054:	8c090913          	addi	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	226080e7          	jalr	550(ra) # 80006280 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2c6080e7          	jalr	710(ra) # 80006334 <release>
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
    8000008e:	c72080e7          	jalr	-910(ra) # 80005cfc <panic>

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
    800000f2:	82250513          	addi	a0,a0,-2014 # 80008910 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0fa080e7          	jalr	250(ra) # 800061f0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00027517          	auipc	a0,0x27
    80000106:	c7e50513          	addi	a0,a0,-898 # 80026d80 <end>
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
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7ec48493          	addi	s1,s1,2028 # 80008910 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	152080e7          	jalr	338(ra) # 80006280 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7d450513          	addi	a0,a0,2004 # 80008910 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	1ee080e7          	jalr	494(ra) # 80006334 <release>

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
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	7a850513          	addi	a0,a0,1960 # 80008910 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1c4080e7          	jalr	452(ra) # 80006334 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8281>
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
    8000032c:	afe080e7          	jalr	-1282(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	5b070713          	addi	a4,a4,1456 # 800088e0 <started>
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
    80000348:	ae2080e7          	jalr	-1310(ra) # 80000e26 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	9f0080e7          	jalr	-1552(ra) # 80005d46 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	7c8080e7          	jalr	1992(ra) # 80001b2e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	e92080e7          	jalr	-366(ra) # 80005200 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	006080e7          	jalr	6(ra) # 8000137c <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	88e080e7          	jalr	-1906(ra) # 80005c0c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	ba0080e7          	jalr	-1120(ra) # 80005f26 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	9b0080e7          	jalr	-1616(ra) # 80005d46 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	9a0080e7          	jalr	-1632(ra) # 80005d46 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	990080e7          	jalr	-1648(ra) # 80005d46 <printf>
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
    800003da:	99c080e7          	jalr	-1636(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	728080e7          	jalr	1832(ra) # 80001b06 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	748080e7          	jalr	1864(ra) # 80001b2e <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	dfc080e7          	jalr	-516(ra) # 800051ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e0a080e7          	jalr	-502(ra) # 80005200 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f98080e7          	jalr	-104(ra) # 80002396 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	638080e7          	jalr	1592(ra) # 80002a3e <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	5de080e7          	jalr	1502(ra) # 800039ec <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ef2080e7          	jalr	-270(ra) # 80005308 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d2e080e7          	jalr	-722(ra) # 8000114c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	4af72a23          	sw	a5,1204(a4) # 800088e0 <started>
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
    80000444:	4a87b783          	ld	a5,1192(a5) # 800088e8 <kernel_pagetable>
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
    80000490:	870080e7          	jalr	-1936(ra) # 80005cfc <panic>
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
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8277>
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
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	74a080e7          	jalr	1866(ra) # 80005cfc <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	73a080e7          	jalr	1850(ra) # 80005cfc <panic>
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
    80000612:	6ee080e7          	jalr	1774(ra) # 80005cfc <panic>

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
    800006da:	608080e7          	jalr	1544(ra) # 80000cde <proc_mapstacks>
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
    80000700:	1ea7b623          	sd	a0,492(a5) # 800088e8 <kernel_pagetable>
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
    8000075e:	5a2080e7          	jalr	1442(ra) # 80005cfc <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	592080e7          	jalr	1426(ra) # 80005cfc <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	582080e7          	jalr	1410(ra) # 80005cfc <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	572080e7          	jalr	1394(ra) # 80005cfc <panic>
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
    8000086c:	494080e7          	jalr	1172(ra) # 80005cfc <panic>

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
    800009b8:	348080e7          	jalr	840(ra) # 80005cfc <panic>
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
    80000a96:	26a080e7          	jalr	618(ra) # 80005cfc <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	25a080e7          	jalr	602(ra) # 80005cfc <panic>
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
    80000b10:	1f0080e7          	jalr	496(ra) # 80005cfc <panic>

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
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8280>
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

0000000080000cde <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cde:	7139                	addi	sp,sp,-64
    80000ce0:	fc06                	sd	ra,56(sp)
    80000ce2:	f822                	sd	s0,48(sp)
    80000ce4:	f426                	sd	s1,40(sp)
    80000ce6:	f04a                	sd	s2,32(sp)
    80000ce8:	ec4e                	sd	s3,24(sp)
    80000cea:	e852                	sd	s4,16(sp)
    80000cec:	e456                	sd	s5,8(sp)
    80000cee:	e05a                	sd	s6,0(sp)
    80000cf0:	0080                	addi	s0,sp,64
    80000cf2:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00008497          	auipc	s1,0x8
    80000cf8:	06c48493          	addi	s1,s1,108 # 80008d60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfc:	8b26                	mv	s6,s1
    80000cfe:	00007a97          	auipc	s5,0x7
    80000d02:	302a8a93          	addi	s5,s5,770 # 80008000 <etext>
    80000d06:	01000937          	lui	s2,0x1000
    80000d0a:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000d0c:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	00013a17          	auipc	s4,0x13
    80000d12:	a52a0a13          	addi	s4,s4,-1454 # 80013760 <tickslock>
    char *pa = kalloc();
    80000d16:	fffff097          	auipc	ra,0xfffff
    80000d1a:	404080e7          	jalr	1028(ra) # 8000011a <kalloc>
    80000d1e:	862a                	mv	a2,a0
    if(pa == 0)
    80000d20:	c129                	beqz	a0,80000d62 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d22:	416485b3          	sub	a1,s1,s6
    80000d26:	858d                	srai	a1,a1,0x3
    80000d28:	000ab783          	ld	a5,0(s5)
    80000d2c:	02f585b3          	mul	a1,a1,a5
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a8080e7          	jalr	-1880(ra) # 800005e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	2a848493          	addi	s1,s1,680
    80000d4a:	fd4496e3          	bne	s1,s4,80000d16 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	f92080e7          	jalr	-110(ra) # 80005cfc <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	ba250513          	addi	a0,a0,-1118 # 80008930 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	45a080e7          	jalr	1114(ra) # 800061f0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	ba250513          	addi	a0,a0,-1118 # 80008948 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	442080e7          	jalr	1090(ra) # 800061f0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	faa48493          	addi	s1,s1,-86 # 80008d60 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	01000937          	lui	s2,0x1000
    80000dd4:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000dd6:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	00013997          	auipc	s3,0x13
    80000ddc:	98898993          	addi	s3,s3,-1656 # 80013760 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	40c080e7          	jalr	1036(ra) # 800061f0 <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	00d7979b          	slliw	a5,a5,0xd
    80000e02:	40f907b3          	sub	a5,s2,a5
    80000e06:	16f4bc23          	sd	a5,376(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	2a848493          	addi	s1,s1,680
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	b1e50513          	addi	a0,a0,-1250 # 80008960 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	3d8080e7          	jalr	984(ra) # 80006234 <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	ac670713          	addi	a4,a4,-1338 # 80008930 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	45e080e7          	jalr	1118(ra) # 800062d4 <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	49a080e7          	jalr	1178(ra) # 80006334 <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	9ce7a783          	lw	a5,-1586(a5) # 80008870 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c9a080e7          	jalr	-870(ra) # 80001b46 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9a07aa23          	sw	zero,-1612(a5) # 80008870 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	af8080e7          	jalr	-1288(ra) # 800029be <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a5490913          	addi	s2,s2,-1452 # 80008930 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	39a080e7          	jalr	922(ra) # 80006280 <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	98678793          	addi	a5,a5,-1658 # 80008874 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	434080e7          	jalr	1076(ra) # 80006334 <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8ac080e7          	jalr	-1876(ra) # 800007d0 <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	602080e7          	jalr	1538(ra) # 80000546 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	19893683          	ld	a3,408(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e4080e7          	jalr	1508(ra) # 80000546 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a56080e7          	jalr	-1450(ra) # 800009d6 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	772080e7          	jalr	1906(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a30080e7          	jalr	-1488(ra) # 800009d6 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73e080e7          	jalr	1854(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	728080e7          	jalr	1832(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e6080e7          	jalr	-1562(ra) # 800009d6 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	19853503          	ld	a0,408(a0)
    80001014:	c509                	beqz	a0,8000101e <freeproc+0x1a>
    kfree((void*)p->trapframe);
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	006080e7          	jalr	6(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101e:	1804bc23          	sd	zero,408(s1)
  if(p->usyscallpage)
    80001022:	1904b503          	ld	a0,400(s1)
    80001026:	c509                	beqz	a0,80001030 <freeproc+0x2c>
    kfree((void *)p->usyscallpage);
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	ff4080e7          	jalr	-12(ra) # 8000001c <kfree>
  p->usyscallpage = 0;
    80001030:	1804b823          	sd	zero,400(s1)
  if(p->pagetable)
    80001034:	1884b503          	ld	a0,392(s1)
    80001038:	c519                	beqz	a0,80001046 <freeproc+0x42>
    proc_freepagetable(p->pagetable, p->sz);
    8000103a:	1804b583          	ld	a1,384(s1)
    8000103e:	00000097          	auipc	ra,0x0
    80001042:	f74080e7          	jalr	-140(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    80001046:	1804b423          	sd	zero,392(s1)
  p->sz = 0;
    8000104a:	1804b023          	sd	zero,384(s1)
  p->pid = 0;
    8000104e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001052:	1604b823          	sd	zero,368(s1)
  p->name[0] = 0;
    80001056:	28048c23          	sb	zero,664(s1)
  p->chan = 0;
    8000105a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000105e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001062:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001066:	0004ac23          	sw	zero,24(s1)
}
    8000106a:	60e2                	ld	ra,24(sp)
    8000106c:	6442                	ld	s0,16(sp)
    8000106e:	64a2                	ld	s1,8(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret

0000000080001074 <allocproc>:
{
    80001074:	1101                	addi	sp,sp,-32
    80001076:	ec06                	sd	ra,24(sp)
    80001078:	e822                	sd	s0,16(sp)
    8000107a:	e426                	sd	s1,8(sp)
    8000107c:	e04a                	sd	s2,0(sp)
    8000107e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	00008497          	auipc	s1,0x8
    80001084:	ce048493          	addi	s1,s1,-800 # 80008d60 <proc>
    80001088:	00012917          	auipc	s2,0x12
    8000108c:	6d890913          	addi	s2,s2,1752 # 80013760 <tickslock>
    acquire(&p->lock);
    80001090:	8526                	mv	a0,s1
    80001092:	00005097          	auipc	ra,0x5
    80001096:	1ee080e7          	jalr	494(ra) # 80006280 <acquire>
    if(p->state == UNUSED) {
    8000109a:	4c9c                	lw	a5,24(s1)
    8000109c:	cf81                	beqz	a5,800010b4 <allocproc+0x40>
      release(&p->lock);
    8000109e:	8526                	mv	a0,s1
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	294080e7          	jalr	660(ra) # 80006334 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	2a848493          	addi	s1,s1,680
    800010ac:	ff2492e3          	bne	s1,s2,80001090 <allocproc+0x1c>
  return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	a8b1                	j	8000110e <allocproc+0x9a>
  p->pid = allocpid();
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	e1c080e7          	jalr	-484(ra) # 80000ed0 <allocpid>
    800010bc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010be:	4785                	li	a5,1
    800010c0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	058080e7          	jalr	88(ra) # 8000011a <kalloc>
    800010ca:	892a                	mv	s2,a0
    800010cc:	18a4bc23          	sd	a0,408(s1)
    800010d0:	c531                	beqz	a0,8000111c <allocproc+0xa8>
  p->pagetable = proc_pagetable(p);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	e42080e7          	jalr	-446(ra) # 80000f16 <proc_pagetable>
    800010dc:	892a                	mv	s2,a0
    800010de:	18a4b423          	sd	a0,392(s1)
  if(p->pagetable == 0){
    800010e2:	c929                	beqz	a0,80001134 <allocproc+0xc0>
  memset(&p->context, 0, sizeof(p->context));
    800010e4:	07000613          	li	a2,112
    800010e8:	4581                	li	a1,0
    800010ea:	1a048513          	addi	a0,s1,416
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	08c080e7          	jalr	140(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010f6:	00000797          	auipc	a5,0x0
    800010fa:	d9478793          	addi	a5,a5,-620 # 80000e8a <forkret>
    800010fe:	1af4b023          	sd	a5,416(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001102:	1784b783          	ld	a5,376(s1)
    80001106:	6705                	lui	a4,0x1
    80001108:	97ba                	add	a5,a5,a4
    8000110a:	1af4b423          	sd	a5,424(s1)
}
    8000110e:	8526                	mv	a0,s1
    80001110:	60e2                	ld	ra,24(sp)
    80001112:	6442                	ld	s0,16(sp)
    80001114:	64a2                	ld	s1,8(sp)
    80001116:	6902                	ld	s2,0(sp)
    80001118:	6105                	addi	sp,sp,32
    8000111a:	8082                	ret
    freeproc(p);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	ee6080e7          	jalr	-282(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001126:	8526                	mv	a0,s1
    80001128:	00005097          	auipc	ra,0x5
    8000112c:	20c080e7          	jalr	524(ra) # 80006334 <release>
    return 0;
    80001130:	84ca                	mv	s1,s2
    80001132:	bff1                	j	8000110e <allocproc+0x9a>
    freeproc(p);
    80001134:	8526                	mv	a0,s1
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	ece080e7          	jalr	-306(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	1f4080e7          	jalr	500(ra) # 80006334 <release>
    return 0;
    80001148:	84ca                	mv	s1,s2
    8000114a:	b7d1                	j	8000110e <allocproc+0x9a>

000000008000114c <userinit>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	1000                	addi	s0,sp,32
  p = allocproc();
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	f1e080e7          	jalr	-226(ra) # 80001074 <allocproc>
    8000115e:	84aa                	mv	s1,a0
  initproc = p;
    80001160:	00007797          	auipc	a5,0x7
    80001164:	78a7b823          	sd	a0,1936(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001168:	03400613          	li	a2,52
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	71458593          	addi	a1,a1,1812 # 80008880 <initcode>
    80001174:	18853503          	ld	a0,392(a0)
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	686080e7          	jalr	1670(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    80001180:	6785                	lui	a5,0x1
    80001182:	18f4b023          	sd	a5,384(s1)
  p->trapframe->epc = 0;      // user program counter
    80001186:	1984b703          	ld	a4,408(s1)
    8000118a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000118e:	1984b703          	ld	a4,408(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fea58593          	addi	a1,a1,-22 # 80008180 <etext+0x180>
    8000119e:	29848513          	addi	a0,s1,664
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	122080e7          	jalr	290(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fe650513          	addi	a0,a0,-26 # 80008190 <etext+0x190>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	236080e7          	jalr	566(ra) # 800033e8 <namei>
    800011ba:	28a4b823          	sd	a0,656(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	170080e7          	jalr	368(ra) # 80006334 <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c6e080e7          	jalr	-914(ra) # 80000e52 <myproc>
    800011ec:	84aa                	mv	s1,a0
  sz = p->sz;
    800011ee:	18053583          	ld	a1,384(a0)
  if(n > 0){
    800011f2:	01204d63          	bgtz	s2,8000120c <growproc+0x36>
  } else if(n < 0){
    800011f6:	02094863          	bltz	s2,80001226 <growproc+0x50>
  p->sz = sz;
    800011fa:	18b4b023          	sd	a1,384(s1)
  return 0;
    800011fe:	4501                	li	a0,0
}
    80001200:	60e2                	ld	ra,24(sp)
    80001202:	6442                	ld	s0,16(sp)
    80001204:	64a2                	ld	s1,8(sp)
    80001206:	6902                	ld	s2,0(sp)
    80001208:	6105                	addi	sp,sp,32
    8000120a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000120c:	4691                	li	a3,4
    8000120e:	00b90633          	add	a2,s2,a1
    80001212:	18853503          	ld	a0,392(a0)
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	6a2080e7          	jalr	1698(ra) # 800008b8 <uvmalloc>
    8000121e:	85aa                	mv	a1,a0
    80001220:	fd69                	bnez	a0,800011fa <growproc+0x24>
      return -1;
    80001222:	557d                	li	a0,-1
    80001224:	bff1                	j	80001200 <growproc+0x2a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001226:	00b90633          	add	a2,s2,a1
    8000122a:	18853503          	ld	a0,392(a0)
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	642080e7          	jalr	1602(ra) # 80000870 <uvmdealloc>
    80001236:	85aa                	mv	a1,a0
    80001238:	b7c9                	j	800011fa <growproc+0x24>

000000008000123a <fork>:
{
    8000123a:	7139                	addi	sp,sp,-64
    8000123c:	fc06                	sd	ra,56(sp)
    8000123e:	f822                	sd	s0,48(sp)
    80001240:	f426                	sd	s1,40(sp)
    80001242:	f04a                	sd	s2,32(sp)
    80001244:	ec4e                	sd	s3,24(sp)
    80001246:	e852                	sd	s4,16(sp)
    80001248:	e456                	sd	s5,8(sp)
    8000124a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	c06080e7          	jalr	-1018(ra) # 80000e52 <myproc>
    80001254:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	e1e080e7          	jalr	-482(ra) # 80001074 <allocproc>
    8000125e:	10050d63          	beqz	a0,80001378 <fork+0x13e>
    80001262:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001264:	180ab603          	ld	a2,384(s5)
    80001268:	18853583          	ld	a1,392(a0)
    8000126c:	188ab503          	ld	a0,392(s5)
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	7a0080e7          	jalr	1952(ra) # 80000a10 <uvmcopy>
    80001278:	04054863          	bltz	a0,800012c8 <fork+0x8e>
  np->sz = p->sz;
    8000127c:	180ab783          	ld	a5,384(s5)
    80001280:	18fa3023          	sd	a5,384(s4)
  *(np->trapframe) = *(p->trapframe);
    80001284:	198ab683          	ld	a3,408(s5)
    80001288:	87b6                	mv	a5,a3
    8000128a:	198a3703          	ld	a4,408(s4)
    8000128e:	12068693          	addi	a3,a3,288
    80001292:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001296:	6788                	ld	a0,8(a5)
    80001298:	6b8c                	ld	a1,16(a5)
    8000129a:	6f90                	ld	a2,24(a5)
    8000129c:	01073023          	sd	a6,0(a4)
    800012a0:	e708                	sd	a0,8(a4)
    800012a2:	eb0c                	sd	a1,16(a4)
    800012a4:	ef10                	sd	a2,24(a4)
    800012a6:	02078793          	addi	a5,a5,32
    800012aa:	02070713          	addi	a4,a4,32
    800012ae:	fed792e3          	bne	a5,a3,80001292 <fork+0x58>
  np->trapframe->a0 = 0;
    800012b2:	198a3783          	ld	a5,408(s4)
    800012b6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012ba:	210a8493          	addi	s1,s5,528
    800012be:	210a0913          	addi	s2,s4,528
    800012c2:	290a8993          	addi	s3,s5,656
    800012c6:	a00d                	j	800012e8 <fork+0xae>
    freeproc(np);
    800012c8:	8552                	mv	a0,s4
    800012ca:	00000097          	auipc	ra,0x0
    800012ce:	d3a080e7          	jalr	-710(ra) # 80001004 <freeproc>
    release(&np->lock);
    800012d2:	8552                	mv	a0,s4
    800012d4:	00005097          	auipc	ra,0x5
    800012d8:	060080e7          	jalr	96(ra) # 80006334 <release>
    return -1;
    800012dc:	597d                	li	s2,-1
    800012de:	a059                	j	80001364 <fork+0x12a>
  for(i = 0; i < NOFILE; i++)
    800012e0:	04a1                	addi	s1,s1,8
    800012e2:	0921                	addi	s2,s2,8
    800012e4:	01348b63          	beq	s1,s3,800012fa <fork+0xc0>
    if(p->ofile[i])
    800012e8:	6088                	ld	a0,0(s1)
    800012ea:	d97d                	beqz	a0,800012e0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ec:	00002097          	auipc	ra,0x2
    800012f0:	792080e7          	jalr	1938(ra) # 80003a7e <filedup>
    800012f4:	00a93023          	sd	a0,0(s2)
    800012f8:	b7e5                	j	800012e0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800012fa:	290ab503          	ld	a0,656(s5)
    800012fe:	00002097          	auipc	ra,0x2
    80001302:	900080e7          	jalr	-1792(ra) # 80002bfe <idup>
    80001306:	28aa3823          	sd	a0,656(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000130a:	4641                	li	a2,16
    8000130c:	298a8593          	addi	a1,s5,664
    80001310:	298a0513          	addi	a0,s4,664
    80001314:	fffff097          	auipc	ra,0xfffff
    80001318:	fb0080e7          	jalr	-80(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    8000131c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001320:	8552                	mv	a0,s4
    80001322:	00005097          	auipc	ra,0x5
    80001326:	012080e7          	jalr	18(ra) # 80006334 <release>
  acquire(&wait_lock);
    8000132a:	00007497          	auipc	s1,0x7
    8000132e:	61e48493          	addi	s1,s1,1566 # 80008948 <wait_lock>
    80001332:	8526                	mv	a0,s1
    80001334:	00005097          	auipc	ra,0x5
    80001338:	f4c080e7          	jalr	-180(ra) # 80006280 <acquire>
  np->parent = p;
    8000133c:	175a3823          	sd	s5,368(s4)
  release(&wait_lock);
    80001340:	8526                	mv	a0,s1
    80001342:	00005097          	auipc	ra,0x5
    80001346:	ff2080e7          	jalr	-14(ra) # 80006334 <release>
  acquire(&np->lock);
    8000134a:	8552                	mv	a0,s4
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	f34080e7          	jalr	-204(ra) # 80006280 <acquire>
  np->state = RUNNABLE;
    80001354:	478d                	li	a5,3
    80001356:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000135a:	8552                	mv	a0,s4
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	fd8080e7          	jalr	-40(ra) # 80006334 <release>
}
    80001364:	854a                	mv	a0,s2
    80001366:	70e2                	ld	ra,56(sp)
    80001368:	7442                	ld	s0,48(sp)
    8000136a:	74a2                	ld	s1,40(sp)
    8000136c:	7902                	ld	s2,32(sp)
    8000136e:	69e2                	ld	s3,24(sp)
    80001370:	6a42                	ld	s4,16(sp)
    80001372:	6aa2                	ld	s5,8(sp)
    80001374:	6121                	addi	sp,sp,64
    80001376:	8082                	ret
    return -1;
    80001378:	597d                	li	s2,-1
    8000137a:	b7ed                	j	80001364 <fork+0x12a>

000000008000137c <scheduler>:
{
    8000137c:	7139                	addi	sp,sp,-64
    8000137e:	fc06                	sd	ra,56(sp)
    80001380:	f822                	sd	s0,48(sp)
    80001382:	f426                	sd	s1,40(sp)
    80001384:	f04a                	sd	s2,32(sp)
    80001386:	ec4e                	sd	s3,24(sp)
    80001388:	e852                	sd	s4,16(sp)
    8000138a:	e456                	sd	s5,8(sp)
    8000138c:	e05a                	sd	s6,0(sp)
    8000138e:	0080                	addi	s0,sp,64
    80001390:	8792                	mv	a5,tp
  int id = r_tp();
    80001392:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001394:	00779a93          	slli	s5,a5,0x7
    80001398:	00007717          	auipc	a4,0x7
    8000139c:	59870713          	addi	a4,a4,1432 # 80008930 <pid_lock>
    800013a0:	9756                	add	a4,a4,s5
    800013a2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013a6:	00007717          	auipc	a4,0x7
    800013aa:	5c270713          	addi	a4,a4,1474 # 80008968 <cpus+0x8>
    800013ae:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013b0:	498d                	li	s3,3
        p->state = RUNNING;
    800013b2:	4b11                	li	s6,4
        c->proc = p;
    800013b4:	079e                	slli	a5,a5,0x7
    800013b6:	00007a17          	auipc	s4,0x7
    800013ba:	57aa0a13          	addi	s4,s4,1402 # 80008930 <pid_lock>
    800013be:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c0:	00012917          	auipc	s2,0x12
    800013c4:	3a090913          	addi	s2,s2,928 # 80013760 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013d0:	10079073          	csrw	sstatus,a5
    800013d4:	00008497          	auipc	s1,0x8
    800013d8:	98c48493          	addi	s1,s1,-1652 # 80008d60 <proc>
    800013dc:	a811                	j	800013f0 <scheduler+0x74>
      release(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	f54080e7          	jalr	-172(ra) # 80006334 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	2a848493          	addi	s1,s1,680
    800013ec:	fd248ee3          	beq	s1,s2,800013c8 <scheduler+0x4c>
      acquire(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	e8e080e7          	jalr	-370(ra) # 80006280 <acquire>
      if(p->state == RUNNABLE) {
    800013fa:	4c9c                	lw	a5,24(s1)
    800013fc:	ff3791e3          	bne	a5,s3,800013de <scheduler+0x62>
        p->state = RUNNING;
    80001400:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001404:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001408:	1a048593          	addi	a1,s1,416
    8000140c:	8556                	mv	a0,s5
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	68e080e7          	jalr	1678(ra) # 80001a9c <swtch>
        c->proc = 0;
    80001416:	020a3823          	sd	zero,48(s4)
    8000141a:	b7d1                	j	800013de <scheduler+0x62>

000000008000141c <sched>:
{
    8000141c:	7179                	addi	sp,sp,-48
    8000141e:	f406                	sd	ra,40(sp)
    80001420:	f022                	sd	s0,32(sp)
    80001422:	ec26                	sd	s1,24(sp)
    80001424:	e84a                	sd	s2,16(sp)
    80001426:	e44e                	sd	s3,8(sp)
    80001428:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	a28080e7          	jalr	-1496(ra) # 80000e52 <myproc>
    80001432:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001434:	00005097          	auipc	ra,0x5
    80001438:	dd2080e7          	jalr	-558(ra) # 80006206 <holding>
    8000143c:	c93d                	beqz	a0,800014b2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001440:	2781                	sext.w	a5,a5
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	00007717          	auipc	a4,0x7
    80001448:	4ec70713          	addi	a4,a4,1260 # 80008930 <pid_lock>
    8000144c:	97ba                	add	a5,a5,a4
    8000144e:	0a87a703          	lw	a4,168(a5)
    80001452:	4785                	li	a5,1
    80001454:	06f71763          	bne	a4,a5,800014c2 <sched+0xa6>
  if(p->state == RUNNING)
    80001458:	4c98                	lw	a4,24(s1)
    8000145a:	4791                	li	a5,4
    8000145c:	06f70b63          	beq	a4,a5,800014d2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001460:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001464:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001466:	efb5                	bnez	a5,800014e2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001468:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000146a:	00007917          	auipc	s2,0x7
    8000146e:	4c690913          	addi	s2,s2,1222 # 80008930 <pid_lock>
    80001472:	2781                	sext.w	a5,a5
    80001474:	079e                	slli	a5,a5,0x7
    80001476:	97ca                	add	a5,a5,s2
    80001478:	0ac7a983          	lw	s3,172(a5)
    8000147c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	00007597          	auipc	a1,0x7
    80001486:	4e658593          	addi	a1,a1,1254 # 80008968 <cpus+0x8>
    8000148a:	95be                	add	a1,a1,a5
    8000148c:	1a048513          	addi	a0,s1,416
    80001490:	00000097          	auipc	ra,0x0
    80001494:	60c080e7          	jalr	1548(ra) # 80001a9c <swtch>
    80001498:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	993e                	add	s2,s2,a5
    800014a0:	0b392623          	sw	s3,172(s2)
}
    800014a4:	70a2                	ld	ra,40(sp)
    800014a6:	7402                	ld	s0,32(sp)
    800014a8:	64e2                	ld	s1,24(sp)
    800014aa:	6942                	ld	s2,16(sp)
    800014ac:	69a2                	ld	s3,8(sp)
    800014ae:	6145                	addi	sp,sp,48
    800014b0:	8082                	ret
    panic("sched p->lock");
    800014b2:	00007517          	auipc	a0,0x7
    800014b6:	ce650513          	addi	a0,a0,-794 # 80008198 <etext+0x198>
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	842080e7          	jalr	-1982(ra) # 80005cfc <panic>
    panic("sched locks");
    800014c2:	00007517          	auipc	a0,0x7
    800014c6:	ce650513          	addi	a0,a0,-794 # 800081a8 <etext+0x1a8>
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	832080e7          	jalr	-1998(ra) # 80005cfc <panic>
    panic("sched running");
    800014d2:	00007517          	auipc	a0,0x7
    800014d6:	ce650513          	addi	a0,a0,-794 # 800081b8 <etext+0x1b8>
    800014da:	00005097          	auipc	ra,0x5
    800014de:	822080e7          	jalr	-2014(ra) # 80005cfc <panic>
    panic("sched interruptible");
    800014e2:	00007517          	auipc	a0,0x7
    800014e6:	ce650513          	addi	a0,a0,-794 # 800081c8 <etext+0x1c8>
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	812080e7          	jalr	-2030(ra) # 80005cfc <panic>

00000000800014f2 <yield>:
{
    800014f2:	1101                	addi	sp,sp,-32
    800014f4:	ec06                	sd	ra,24(sp)
    800014f6:	e822                	sd	s0,16(sp)
    800014f8:	e426                	sd	s1,8(sp)
    800014fa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	956080e7          	jalr	-1706(ra) # 80000e52 <myproc>
    80001504:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	d7a080e7          	jalr	-646(ra) # 80006280 <acquire>
  p->state = RUNNABLE;
    8000150e:	478d                	li	a5,3
    80001510:	cc9c                	sw	a5,24(s1)
  sched();
    80001512:	00000097          	auipc	ra,0x0
    80001516:	f0a080e7          	jalr	-246(ra) # 8000141c <sched>
  release(&p->lock);
    8000151a:	8526                	mv	a0,s1
    8000151c:	00005097          	auipc	ra,0x5
    80001520:	e18080e7          	jalr	-488(ra) # 80006334 <release>
}
    80001524:	60e2                	ld	ra,24(sp)
    80001526:	6442                	ld	s0,16(sp)
    80001528:	64a2                	ld	s1,8(sp)
    8000152a:	6105                	addi	sp,sp,32
    8000152c:	8082                	ret

000000008000152e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000152e:	7179                	addi	sp,sp,-48
    80001530:	f406                	sd	ra,40(sp)
    80001532:	f022                	sd	s0,32(sp)
    80001534:	ec26                	sd	s1,24(sp)
    80001536:	e84a                	sd	s2,16(sp)
    80001538:	e44e                	sd	s3,8(sp)
    8000153a:	1800                	addi	s0,sp,48
    8000153c:	89aa                	mv	s3,a0
    8000153e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001540:	00000097          	auipc	ra,0x0
    80001544:	912080e7          	jalr	-1774(ra) # 80000e52 <myproc>
    80001548:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	d36080e7          	jalr	-714(ra) # 80006280 <acquire>
  release(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	00005097          	auipc	ra,0x5
    80001558:	de0080e7          	jalr	-544(ra) # 80006334 <release>

  // Go to sleep.
  p->chan = chan;
    8000155c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001560:	4789                	li	a5,2
    80001562:	cc9c                	sw	a5,24(s1)

  sched();
    80001564:	00000097          	auipc	ra,0x0
    80001568:	eb8080e7          	jalr	-328(ra) # 8000141c <sched>

  // Tidy up.
  p->chan = 0;
    8000156c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	dc2080e7          	jalr	-574(ra) # 80006334 <release>
  acquire(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	d04080e7          	jalr	-764(ra) # 80006280 <acquire>
}
    80001584:	70a2                	ld	ra,40(sp)
    80001586:	7402                	ld	s0,32(sp)
    80001588:	64e2                	ld	s1,24(sp)
    8000158a:	6942                	ld	s2,16(sp)
    8000158c:	69a2                	ld	s3,8(sp)
    8000158e:	6145                	addi	sp,sp,48
    80001590:	8082                	ret

0000000080001592 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001592:	7139                	addi	sp,sp,-64
    80001594:	fc06                	sd	ra,56(sp)
    80001596:	f822                	sd	s0,48(sp)
    80001598:	f426                	sd	s1,40(sp)
    8000159a:	f04a                	sd	s2,32(sp)
    8000159c:	ec4e                	sd	s3,24(sp)
    8000159e:	e852                	sd	s4,16(sp)
    800015a0:	e456                	sd	s5,8(sp)
    800015a2:	0080                	addi	s0,sp,64
    800015a4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015a6:	00007497          	auipc	s1,0x7
    800015aa:	7ba48493          	addi	s1,s1,1978 # 80008d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015ae:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015b0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015b2:	00012917          	auipc	s2,0x12
    800015b6:	1ae90913          	addi	s2,s2,430 # 80013760 <tickslock>
    800015ba:	a811                	j	800015ce <wakeup+0x3c>
      }
      release(&p->lock);
    800015bc:	8526                	mv	a0,s1
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	d76080e7          	jalr	-650(ra) # 80006334 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015c6:	2a848493          	addi	s1,s1,680
    800015ca:	03248663          	beq	s1,s2,800015f6 <wakeup+0x64>
    if(p != myproc()){
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	884080e7          	jalr	-1916(ra) # 80000e52 <myproc>
    800015d6:	fea488e3          	beq	s1,a0,800015c6 <wakeup+0x34>
      acquire(&p->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	ca4080e7          	jalr	-860(ra) # 80006280 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015e4:	4c9c                	lw	a5,24(s1)
    800015e6:	fd379be3          	bne	a5,s3,800015bc <wakeup+0x2a>
    800015ea:	709c                	ld	a5,32(s1)
    800015ec:	fd4798e3          	bne	a5,s4,800015bc <wakeup+0x2a>
        p->state = RUNNABLE;
    800015f0:	0154ac23          	sw	s5,24(s1)
    800015f4:	b7e1                	j	800015bc <wakeup+0x2a>
    }
  }
}
    800015f6:	70e2                	ld	ra,56(sp)
    800015f8:	7442                	ld	s0,48(sp)
    800015fa:	74a2                	ld	s1,40(sp)
    800015fc:	7902                	ld	s2,32(sp)
    800015fe:	69e2                	ld	s3,24(sp)
    80001600:	6a42                	ld	s4,16(sp)
    80001602:	6aa2                	ld	s5,8(sp)
    80001604:	6121                	addi	sp,sp,64
    80001606:	8082                	ret

0000000080001608 <reparent>:
{
    80001608:	7179                	addi	sp,sp,-48
    8000160a:	f406                	sd	ra,40(sp)
    8000160c:	f022                	sd	s0,32(sp)
    8000160e:	ec26                	sd	s1,24(sp)
    80001610:	e84a                	sd	s2,16(sp)
    80001612:	e44e                	sd	s3,8(sp)
    80001614:	e052                	sd	s4,0(sp)
    80001616:	1800                	addi	s0,sp,48
    80001618:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000161a:	00007497          	auipc	s1,0x7
    8000161e:	74648493          	addi	s1,s1,1862 # 80008d60 <proc>
      pp->parent = initproc;
    80001622:	00007a17          	auipc	s4,0x7
    80001626:	2cea0a13          	addi	s4,s4,718 # 800088f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000162a:	00012997          	auipc	s3,0x12
    8000162e:	13698993          	addi	s3,s3,310 # 80013760 <tickslock>
    80001632:	a029                	j	8000163c <reparent+0x34>
    80001634:	2a848493          	addi	s1,s1,680
    80001638:	01348f63          	beq	s1,s3,80001656 <reparent+0x4e>
    if(pp->parent == p){
    8000163c:	1704b783          	ld	a5,368(s1)
    80001640:	ff279ae3          	bne	a5,s2,80001634 <reparent+0x2c>
      pp->parent = initproc;
    80001644:	000a3503          	ld	a0,0(s4)
    80001648:	16a4b823          	sd	a0,368(s1)
      wakeup(initproc);
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	f46080e7          	jalr	-186(ra) # 80001592 <wakeup>
    80001654:	b7c5                	j	80001634 <reparent+0x2c>
}
    80001656:	70a2                	ld	ra,40(sp)
    80001658:	7402                	ld	s0,32(sp)
    8000165a:	64e2                	ld	s1,24(sp)
    8000165c:	6942                	ld	s2,16(sp)
    8000165e:	69a2                	ld	s3,8(sp)
    80001660:	6a02                	ld	s4,0(sp)
    80001662:	6145                	addi	sp,sp,48
    80001664:	8082                	ret

0000000080001666 <exit>:
{
    80001666:	7179                	addi	sp,sp,-48
    80001668:	f406                	sd	ra,40(sp)
    8000166a:	f022                	sd	s0,32(sp)
    8000166c:	ec26                	sd	s1,24(sp)
    8000166e:	e84a                	sd	s2,16(sp)
    80001670:	e44e                	sd	s3,8(sp)
    80001672:	e052                	sd	s4,0(sp)
    80001674:	1800                	addi	s0,sp,48
    80001676:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001678:	fffff097          	auipc	ra,0xfffff
    8000167c:	7da080e7          	jalr	2010(ra) # 80000e52 <myproc>
    80001680:	89aa                	mv	s3,a0
  if(p == initproc)
    80001682:	00007797          	auipc	a5,0x7
    80001686:	26e7b783          	ld	a5,622(a5) # 800088f0 <initproc>
    8000168a:	21050493          	addi	s1,a0,528
    8000168e:	29050913          	addi	s2,a0,656
    80001692:	02a79363          	bne	a5,a0,800016b8 <exit+0x52>
    panic("init exiting");
    80001696:	00007517          	auipc	a0,0x7
    8000169a:	b4a50513          	addi	a0,a0,-1206 # 800081e0 <etext+0x1e0>
    8000169e:	00004097          	auipc	ra,0x4
    800016a2:	65e080e7          	jalr	1630(ra) # 80005cfc <panic>
      fileclose(f);
    800016a6:	00002097          	auipc	ra,0x2
    800016aa:	42a080e7          	jalr	1066(ra) # 80003ad0 <fileclose>
      p->ofile[fd] = 0;
    800016ae:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016b2:	04a1                	addi	s1,s1,8
    800016b4:	01248563          	beq	s1,s2,800016be <exit+0x58>
    if(p->ofile[fd]){
    800016b8:	6088                	ld	a0,0(s1)
    800016ba:	f575                	bnez	a0,800016a6 <exit+0x40>
    800016bc:	bfdd                	j	800016b2 <exit+0x4c>
  begin_op();
    800016be:	00002097          	auipc	ra,0x2
    800016c2:	f4a080e7          	jalr	-182(ra) # 80003608 <begin_op>
  iput(p->cwd);
    800016c6:	2909b503          	ld	a0,656(s3)
    800016ca:	00001097          	auipc	ra,0x1
    800016ce:	72c080e7          	jalr	1836(ra) # 80002df6 <iput>
  end_op();
    800016d2:	00002097          	auipc	ra,0x2
    800016d6:	fb4080e7          	jalr	-76(ra) # 80003686 <end_op>
  p->cwd = 0;
    800016da:	2809b823          	sd	zero,656(s3)
  acquire(&wait_lock);
    800016de:	00007497          	auipc	s1,0x7
    800016e2:	26a48493          	addi	s1,s1,618 # 80008948 <wait_lock>
    800016e6:	8526                	mv	a0,s1
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	b98080e7          	jalr	-1128(ra) # 80006280 <acquire>
  reparent(p);
    800016f0:	854e                	mv	a0,s3
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	f16080e7          	jalr	-234(ra) # 80001608 <reparent>
  wakeup(p->parent);
    800016fa:	1709b503          	ld	a0,368(s3)
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	e94080e7          	jalr	-364(ra) # 80001592 <wakeup>
  acquire(&p->lock);
    80001706:	854e                	mv	a0,s3
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	b78080e7          	jalr	-1160(ra) # 80006280 <acquire>
  p->xstate = status;
    80001710:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001714:	4795                	li	a5,5
    80001716:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	c18080e7          	jalr	-1000(ra) # 80006334 <release>
  sched();
    80001724:	00000097          	auipc	ra,0x0
    80001728:	cf8080e7          	jalr	-776(ra) # 8000141c <sched>
  panic("zombie exit");
    8000172c:	00007517          	auipc	a0,0x7
    80001730:	ac450513          	addi	a0,a0,-1340 # 800081f0 <etext+0x1f0>
    80001734:	00004097          	auipc	ra,0x4
    80001738:	5c8080e7          	jalr	1480(ra) # 80005cfc <panic>

000000008000173c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000173c:	7179                	addi	sp,sp,-48
    8000173e:	f406                	sd	ra,40(sp)
    80001740:	f022                	sd	s0,32(sp)
    80001742:	ec26                	sd	s1,24(sp)
    80001744:	e84a                	sd	s2,16(sp)
    80001746:	e44e                	sd	s3,8(sp)
    80001748:	1800                	addi	s0,sp,48
    8000174a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000174c:	00007497          	auipc	s1,0x7
    80001750:	61448493          	addi	s1,s1,1556 # 80008d60 <proc>
    80001754:	00012997          	auipc	s3,0x12
    80001758:	00c98993          	addi	s3,s3,12 # 80013760 <tickslock>
    acquire(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	b22080e7          	jalr	-1246(ra) # 80006280 <acquire>
    if(p->pid == pid){
    80001766:	589c                	lw	a5,48(s1)
    80001768:	01278d63          	beq	a5,s2,80001782 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	bc6080e7          	jalr	-1082(ra) # 80006334 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001776:	2a848493          	addi	s1,s1,680
    8000177a:	ff3491e3          	bne	s1,s3,8000175c <kill+0x20>
  }
  return -1;
    8000177e:	557d                	li	a0,-1
    80001780:	a829                	j	8000179a <kill+0x5e>
      p->killed = 1;
    80001782:	4785                	li	a5,1
    80001784:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001786:	4c98                	lw	a4,24(s1)
    80001788:	4789                	li	a5,2
    8000178a:	00f70f63          	beq	a4,a5,800017a8 <kill+0x6c>
      release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	ba4080e7          	jalr	-1116(ra) # 80006334 <release>
      return 0;
    80001798:	4501                	li	a0,0
}
    8000179a:	70a2                	ld	ra,40(sp)
    8000179c:	7402                	ld	s0,32(sp)
    8000179e:	64e2                	ld	s1,24(sp)
    800017a0:	6942                	ld	s2,16(sp)
    800017a2:	69a2                	ld	s3,8(sp)
    800017a4:	6145                	addi	sp,sp,48
    800017a6:	8082                	ret
        p->state = RUNNABLE;
    800017a8:	478d                	li	a5,3
    800017aa:	cc9c                	sw	a5,24(s1)
    800017ac:	b7cd                	j	8000178e <kill+0x52>

00000000800017ae <setkilled>:

void
setkilled(struct proc *p)
{
    800017ae:	1101                	addi	sp,sp,-32
    800017b0:	ec06                	sd	ra,24(sp)
    800017b2:	e822                	sd	s0,16(sp)
    800017b4:	e426                	sd	s1,8(sp)
    800017b6:	1000                	addi	s0,sp,32
    800017b8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017ba:	00005097          	auipc	ra,0x5
    800017be:	ac6080e7          	jalr	-1338(ra) # 80006280 <acquire>
  p->killed = 1;
    800017c2:	4785                	li	a5,1
    800017c4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017c6:	8526                	mv	a0,s1
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	b6c080e7          	jalr	-1172(ra) # 80006334 <release>
}
    800017d0:	60e2                	ld	ra,24(sp)
    800017d2:	6442                	ld	s0,16(sp)
    800017d4:	64a2                	ld	s1,8(sp)
    800017d6:	6105                	addi	sp,sp,32
    800017d8:	8082                	ret

00000000800017da <killed>:

int
killed(struct proc *p)
{
    800017da:	1101                	addi	sp,sp,-32
    800017dc:	ec06                	sd	ra,24(sp)
    800017de:	e822                	sd	s0,16(sp)
    800017e0:	e426                	sd	s1,8(sp)
    800017e2:	e04a                	sd	s2,0(sp)
    800017e4:	1000                	addi	s0,sp,32
    800017e6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	a98080e7          	jalr	-1384(ra) # 80006280 <acquire>
  k = p->killed;
    800017f0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017f4:	8526                	mv	a0,s1
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	b3e080e7          	jalr	-1218(ra) # 80006334 <release>
  return k;
}
    800017fe:	854a                	mv	a0,s2
    80001800:	60e2                	ld	ra,24(sp)
    80001802:	6442                	ld	s0,16(sp)
    80001804:	64a2                	ld	s1,8(sp)
    80001806:	6902                	ld	s2,0(sp)
    80001808:	6105                	addi	sp,sp,32
    8000180a:	8082                	ret

000000008000180c <wait>:
{
    8000180c:	715d                	addi	sp,sp,-80
    8000180e:	e486                	sd	ra,72(sp)
    80001810:	e0a2                	sd	s0,64(sp)
    80001812:	fc26                	sd	s1,56(sp)
    80001814:	f84a                	sd	s2,48(sp)
    80001816:	f44e                	sd	s3,40(sp)
    80001818:	f052                	sd	s4,32(sp)
    8000181a:	ec56                	sd	s5,24(sp)
    8000181c:	e85a                	sd	s6,16(sp)
    8000181e:	e45e                	sd	s7,8(sp)
    80001820:	e062                	sd	s8,0(sp)
    80001822:	0880                	addi	s0,sp,80
    80001824:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001826:	fffff097          	auipc	ra,0xfffff
    8000182a:	62c080e7          	jalr	1580(ra) # 80000e52 <myproc>
    8000182e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001830:	00007517          	auipc	a0,0x7
    80001834:	11850513          	addi	a0,a0,280 # 80008948 <wait_lock>
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	a48080e7          	jalr	-1464(ra) # 80006280 <acquire>
    havekids = 0;
    80001840:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001842:	4a15                	li	s4,5
        havekids = 1;
    80001844:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001846:	00012997          	auipc	s3,0x12
    8000184a:	f1a98993          	addi	s3,s3,-230 # 80013760 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000184e:	00007c17          	auipc	s8,0x7
    80001852:	0fac0c13          	addi	s8,s8,250 # 80008948 <wait_lock>
    havekids = 0;
    80001856:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001858:	00007497          	auipc	s1,0x7
    8000185c:	50848493          	addi	s1,s1,1288 # 80008d60 <proc>
    80001860:	a0bd                	j	800018ce <wait+0xc2>
          pid = pp->pid;
    80001862:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001866:	000b0e63          	beqz	s6,80001882 <wait+0x76>
    8000186a:	4691                	li	a3,4
    8000186c:	02c48613          	addi	a2,s1,44
    80001870:	85da                	mv	a1,s6
    80001872:	18893503          	ld	a0,392(s2)
    80001876:	fffff097          	auipc	ra,0xfffff
    8000187a:	29e080e7          	jalr	670(ra) # 80000b14 <copyout>
    8000187e:	02054563          	bltz	a0,800018a8 <wait+0x9c>
          freeproc(pp);
    80001882:	8526                	mv	a0,s1
    80001884:	fffff097          	auipc	ra,0xfffff
    80001888:	780080e7          	jalr	1920(ra) # 80001004 <freeproc>
          release(&pp->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	aa6080e7          	jalr	-1370(ra) # 80006334 <release>
          release(&wait_lock);
    80001896:	00007517          	auipc	a0,0x7
    8000189a:	0b250513          	addi	a0,a0,178 # 80008948 <wait_lock>
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	a96080e7          	jalr	-1386(ra) # 80006334 <release>
          return pid;
    800018a6:	a0bd                	j	80001914 <wait+0x108>
            release(&pp->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	a8a080e7          	jalr	-1398(ra) # 80006334 <release>
            release(&wait_lock);
    800018b2:	00007517          	auipc	a0,0x7
    800018b6:	09650513          	addi	a0,a0,150 # 80008948 <wait_lock>
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	a7a080e7          	jalr	-1414(ra) # 80006334 <release>
            return -1;
    800018c2:	59fd                	li	s3,-1
    800018c4:	a881                	j	80001914 <wait+0x108>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c6:	2a848493          	addi	s1,s1,680
    800018ca:	03348563          	beq	s1,s3,800018f4 <wait+0xe8>
      if(pp->parent == p){
    800018ce:	1704b783          	ld	a5,368(s1)
    800018d2:	ff279ae3          	bne	a5,s2,800018c6 <wait+0xba>
        acquire(&pp->lock);
    800018d6:	8526                	mv	a0,s1
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	9a8080e7          	jalr	-1624(ra) # 80006280 <acquire>
        if(pp->state == ZOMBIE){
    800018e0:	4c9c                	lw	a5,24(s1)
    800018e2:	f94780e3          	beq	a5,s4,80001862 <wait+0x56>
        release(&pp->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	a4c080e7          	jalr	-1460(ra) # 80006334 <release>
        havekids = 1;
    800018f0:	8756                	mv	a4,s5
    800018f2:	bfd1                	j	800018c6 <wait+0xba>
    if(!havekids || killed(p)){
    800018f4:	c719                	beqz	a4,80001902 <wait+0xf6>
    800018f6:	854a                	mv	a0,s2
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	ee2080e7          	jalr	-286(ra) # 800017da <killed>
    80001900:	c51d                	beqz	a0,8000192e <wait+0x122>
      release(&wait_lock);
    80001902:	00007517          	auipc	a0,0x7
    80001906:	04650513          	addi	a0,a0,70 # 80008948 <wait_lock>
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	a2a080e7          	jalr	-1494(ra) # 80006334 <release>
      return -1;
    80001912:	59fd                	li	s3,-1
}
    80001914:	854e                	mv	a0,s3
    80001916:	60a6                	ld	ra,72(sp)
    80001918:	6406                	ld	s0,64(sp)
    8000191a:	74e2                	ld	s1,56(sp)
    8000191c:	7942                	ld	s2,48(sp)
    8000191e:	79a2                	ld	s3,40(sp)
    80001920:	7a02                	ld	s4,32(sp)
    80001922:	6ae2                	ld	s5,24(sp)
    80001924:	6b42                	ld	s6,16(sp)
    80001926:	6ba2                	ld	s7,8(sp)
    80001928:	6c02                	ld	s8,0(sp)
    8000192a:	6161                	addi	sp,sp,80
    8000192c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000192e:	85e2                	mv	a1,s8
    80001930:	854a                	mv	a0,s2
    80001932:	00000097          	auipc	ra,0x0
    80001936:	bfc080e7          	jalr	-1028(ra) # 8000152e <sleep>
    havekids = 0;
    8000193a:	bf31                	j	80001856 <wait+0x4a>

000000008000193c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000193c:	7179                	addi	sp,sp,-48
    8000193e:	f406                	sd	ra,40(sp)
    80001940:	f022                	sd	s0,32(sp)
    80001942:	ec26                	sd	s1,24(sp)
    80001944:	e84a                	sd	s2,16(sp)
    80001946:	e44e                	sd	s3,8(sp)
    80001948:	e052                	sd	s4,0(sp)
    8000194a:	1800                	addi	s0,sp,48
    8000194c:	84aa                	mv	s1,a0
    8000194e:	892e                	mv	s2,a1
    80001950:	89b2                	mv	s3,a2
    80001952:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	4fe080e7          	jalr	1278(ra) # 80000e52 <myproc>
  if(user_dst){
    8000195c:	c095                	beqz	s1,80001980 <either_copyout+0x44>
    return copyout(p->pagetable, dst, src, len);
    8000195e:	86d2                	mv	a3,s4
    80001960:	864e                	mv	a2,s3
    80001962:	85ca                	mv	a1,s2
    80001964:	18853503          	ld	a0,392(a0)
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	1ac080e7          	jalr	428(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001970:	70a2                	ld	ra,40(sp)
    80001972:	7402                	ld	s0,32(sp)
    80001974:	64e2                	ld	s1,24(sp)
    80001976:	6942                	ld	s2,16(sp)
    80001978:	69a2                	ld	s3,8(sp)
    8000197a:	6a02                	ld	s4,0(sp)
    8000197c:	6145                	addi	sp,sp,48
    8000197e:	8082                	ret
    memmove((char *)dst, src, len);
    80001980:	000a061b          	sext.w	a2,s4
    80001984:	85ce                	mv	a1,s3
    80001986:	854a                	mv	a0,s2
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	84e080e7          	jalr	-1970(ra) # 800001d6 <memmove>
    return 0;
    80001990:	8526                	mv	a0,s1
    80001992:	bff9                	j	80001970 <either_copyout+0x34>

0000000080001994 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001994:	7179                	addi	sp,sp,-48
    80001996:	f406                	sd	ra,40(sp)
    80001998:	f022                	sd	s0,32(sp)
    8000199a:	ec26                	sd	s1,24(sp)
    8000199c:	e84a                	sd	s2,16(sp)
    8000199e:	e44e                	sd	s3,8(sp)
    800019a0:	e052                	sd	s4,0(sp)
    800019a2:	1800                	addi	s0,sp,48
    800019a4:	892a                	mv	s2,a0
    800019a6:	84ae                	mv	s1,a1
    800019a8:	89b2                	mv	s3,a2
    800019aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	4a6080e7          	jalr	1190(ra) # 80000e52 <myproc>
  if(user_src){
    800019b4:	c095                	beqz	s1,800019d8 <either_copyin+0x44>
    return copyin(p->pagetable, dst, src, len);
    800019b6:	86d2                	mv	a3,s4
    800019b8:	864e                	mv	a2,s3
    800019ba:	85ca                	mv	a1,s2
    800019bc:	18853503          	ld	a0,392(a0)
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	1e0080e7          	jalr	480(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019c8:	70a2                	ld	ra,40(sp)
    800019ca:	7402                	ld	s0,32(sp)
    800019cc:	64e2                	ld	s1,24(sp)
    800019ce:	6942                	ld	s2,16(sp)
    800019d0:	69a2                	ld	s3,8(sp)
    800019d2:	6a02                	ld	s4,0(sp)
    800019d4:	6145                	addi	sp,sp,48
    800019d6:	8082                	ret
    memmove(dst, (char*)src, len);
    800019d8:	000a061b          	sext.w	a2,s4
    800019dc:	85ce                	mv	a1,s3
    800019de:	854a                	mv	a0,s2
    800019e0:	ffffe097          	auipc	ra,0xffffe
    800019e4:	7f6080e7          	jalr	2038(ra) # 800001d6 <memmove>
    return 0;
    800019e8:	8526                	mv	a0,s1
    800019ea:	bff9                	j	800019c8 <either_copyin+0x34>

00000000800019ec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ec:	715d                	addi	sp,sp,-80
    800019ee:	e486                	sd	ra,72(sp)
    800019f0:	e0a2                	sd	s0,64(sp)
    800019f2:	fc26                	sd	s1,56(sp)
    800019f4:	f84a                	sd	s2,48(sp)
    800019f6:	f44e                	sd	s3,40(sp)
    800019f8:	f052                	sd	s4,32(sp)
    800019fa:	ec56                	sd	s5,24(sp)
    800019fc:	e85a                	sd	s6,16(sp)
    800019fe:	e45e                	sd	s7,8(sp)
    80001a00:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a02:	00006517          	auipc	a0,0x6
    80001a06:	64650513          	addi	a0,a0,1606 # 80008048 <etext+0x48>
    80001a0a:	00004097          	auipc	ra,0x4
    80001a0e:	33c080e7          	jalr	828(ra) # 80005d46 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a12:	00007497          	auipc	s1,0x7
    80001a16:	5e648493          	addi	s1,s1,1510 # 80008ff8 <proc+0x298>
    80001a1a:	00012917          	auipc	s2,0x12
    80001a1e:	fde90913          	addi	s2,s2,-34 # 800139f8 <bcache+0x280>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a22:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a24:	00006997          	auipc	s3,0x6
    80001a28:	7dc98993          	addi	s3,s3,2012 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a2c:	00006a97          	auipc	s5,0x6
    80001a30:	7dca8a93          	addi	s5,s5,2012 # 80008208 <etext+0x208>
    printf("\n");
    80001a34:	00006a17          	auipc	s4,0x6
    80001a38:	614a0a13          	addi	s4,s4,1556 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3c:	00007b97          	auipc	s7,0x7
    80001a40:	80cb8b93          	addi	s7,s7,-2036 # 80008248 <states.0>
    80001a44:	a00d                	j	80001a66 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a46:	d986a583          	lw	a1,-616(a3)
    80001a4a:	8556                	mv	a0,s5
    80001a4c:	00004097          	auipc	ra,0x4
    80001a50:	2fa080e7          	jalr	762(ra) # 80005d46 <printf>
    printf("\n");
    80001a54:	8552                	mv	a0,s4
    80001a56:	00004097          	auipc	ra,0x4
    80001a5a:	2f0080e7          	jalr	752(ra) # 80005d46 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5e:	2a848493          	addi	s1,s1,680
    80001a62:	03248263          	beq	s1,s2,80001a86 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a66:	86a6                	mv	a3,s1
    80001a68:	d804a783          	lw	a5,-640(s1)
    80001a6c:	dbed                	beqz	a5,80001a5e <procdump+0x72>
      state = "???";
    80001a6e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a70:	fcfb6be3          	bltu	s6,a5,80001a46 <procdump+0x5a>
    80001a74:	02079713          	slli	a4,a5,0x20
    80001a78:	01d75793          	srli	a5,a4,0x1d
    80001a7c:	97de                	add	a5,a5,s7
    80001a7e:	6390                	ld	a2,0(a5)
    80001a80:	f279                	bnez	a2,80001a46 <procdump+0x5a>
      state = "???";
    80001a82:	864e                	mv	a2,s3
    80001a84:	b7c9                	j	80001a46 <procdump+0x5a>
  }
}
    80001a86:	60a6                	ld	ra,72(sp)
    80001a88:	6406                	ld	s0,64(sp)
    80001a8a:	74e2                	ld	s1,56(sp)
    80001a8c:	7942                	ld	s2,48(sp)
    80001a8e:	79a2                	ld	s3,40(sp)
    80001a90:	7a02                	ld	s4,32(sp)
    80001a92:	6ae2                	ld	s5,24(sp)
    80001a94:	6b42                	ld	s6,16(sp)
    80001a96:	6ba2                	ld	s7,8(sp)
    80001a98:	6161                	addi	sp,sp,80
    80001a9a:	8082                	ret

0000000080001a9c <swtch>:
    80001a9c:	00153023          	sd	ra,0(a0)
    80001aa0:	00253423          	sd	sp,8(a0)
    80001aa4:	e900                	sd	s0,16(a0)
    80001aa6:	ed04                	sd	s1,24(a0)
    80001aa8:	03253023          	sd	s2,32(a0)
    80001aac:	03353423          	sd	s3,40(a0)
    80001ab0:	03453823          	sd	s4,48(a0)
    80001ab4:	03553c23          	sd	s5,56(a0)
    80001ab8:	05653023          	sd	s6,64(a0)
    80001abc:	05753423          	sd	s7,72(a0)
    80001ac0:	05853823          	sd	s8,80(a0)
    80001ac4:	05953c23          	sd	s9,88(a0)
    80001ac8:	07a53023          	sd	s10,96(a0)
    80001acc:	07b53423          	sd	s11,104(a0)
    80001ad0:	0005b083          	ld	ra,0(a1)
    80001ad4:	0085b103          	ld	sp,8(a1)
    80001ad8:	6980                	ld	s0,16(a1)
    80001ada:	6d84                	ld	s1,24(a1)
    80001adc:	0205b903          	ld	s2,32(a1)
    80001ae0:	0285b983          	ld	s3,40(a1)
    80001ae4:	0305ba03          	ld	s4,48(a1)
    80001ae8:	0385ba83          	ld	s5,56(a1)
    80001aec:	0405bb03          	ld	s6,64(a1)
    80001af0:	0485bb83          	ld	s7,72(a1)
    80001af4:	0505bc03          	ld	s8,80(a1)
    80001af8:	0585bc83          	ld	s9,88(a1)
    80001afc:	0605bd03          	ld	s10,96(a1)
    80001b00:	0685bd83          	ld	s11,104(a1)
    80001b04:	8082                	ret

0000000080001b06 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b06:	1141                	addi	sp,sp,-16
    80001b08:	e406                	sd	ra,8(sp)
    80001b0a:	e022                	sd	s0,0(sp)
    80001b0c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b0e:	00006597          	auipc	a1,0x6
    80001b12:	76a58593          	addi	a1,a1,1898 # 80008278 <states.0+0x30>
    80001b16:	00012517          	auipc	a0,0x12
    80001b1a:	c4a50513          	addi	a0,a0,-950 # 80013760 <tickslock>
    80001b1e:	00004097          	auipc	ra,0x4
    80001b22:	6d2080e7          	jalr	1746(ra) # 800061f0 <initlock>
}
    80001b26:	60a2                	ld	ra,8(sp)
    80001b28:	6402                	ld	s0,0(sp)
    80001b2a:	0141                	addi	sp,sp,16
    80001b2c:	8082                	ret

0000000080001b2e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b2e:	1141                	addi	sp,sp,-16
    80001b30:	e422                	sd	s0,8(sp)
    80001b32:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b34:	00003797          	auipc	a5,0x3
    80001b38:	5fc78793          	addi	a5,a5,1532 # 80005130 <kernelvec>
    80001b3c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b40:	6422                	ld	s0,8(sp)
    80001b42:	0141                	addi	sp,sp,16
    80001b44:	8082                	ret

0000000080001b46 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b46:	1141                	addi	sp,sp,-16
    80001b48:	e406                	sd	ra,8(sp)
    80001b4a:	e022                	sd	s0,0(sp)
    80001b4c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	304080e7          	jalr	772(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b60:	00005697          	auipc	a3,0x5
    80001b64:	4a068693          	addi	a3,a3,1184 # 80007000 <_trampoline>
    80001b68:	00005717          	auipc	a4,0x5
    80001b6c:	49870713          	addi	a4,a4,1176 # 80007000 <_trampoline>
    80001b70:	8f15                	sub	a4,a4,a3
    80001b72:	040007b7          	lui	a5,0x4000
    80001b76:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b78:	07b2                	slli	a5,a5,0xc
    80001b7a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b80:	19853703          	ld	a4,408(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b84:	18002673          	csrr	a2,satp
    80001b88:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b8a:	19853603          	ld	a2,408(a0)
    80001b8e:	17853703          	ld	a4,376(a0)
    80001b92:	6585                	lui	a1,0x1
    80001b94:	972e                	add	a4,a4,a1
    80001b96:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b98:	19853703          	ld	a4,408(a0)
    80001b9c:	00000617          	auipc	a2,0x0
    80001ba0:	13660613          	addi	a2,a2,310 # 80001cd2 <usertrap>
    80001ba4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ba6:	19853703          	ld	a4,408(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001baa:	8612                	mv	a2,tp
    80001bac:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bae:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bb6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bba:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bbe:	19853703          	ld	a4,408(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc2:	6f18                	ld	a4,24(a4)
    80001bc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bc8:	18853503          	ld	a0,392(a0)
    80001bcc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bce:	00005717          	auipc	a4,0x5
    80001bd2:	4ce70713          	addi	a4,a4,1230 # 8000709c <userret>
    80001bd6:	8f15                	sub	a4,a4,a3
    80001bd8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bda:	577d                	li	a4,-1
    80001bdc:	177e                	slli	a4,a4,0x3f
    80001bde:	8d59                	or	a0,a0,a4
    80001be0:	9782                	jalr	a5
}
    80001be2:	60a2                	ld	ra,8(sp)
    80001be4:	6402                	ld	s0,0(sp)
    80001be6:	0141                	addi	sp,sp,16
    80001be8:	8082                	ret

0000000080001bea <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bea:	1101                	addi	sp,sp,-32
    80001bec:	ec06                	sd	ra,24(sp)
    80001bee:	e822                	sd	s0,16(sp)
    80001bf0:	e426                	sd	s1,8(sp)
    80001bf2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bf4:	00012497          	auipc	s1,0x12
    80001bf8:	b6c48493          	addi	s1,s1,-1172 # 80013760 <tickslock>
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00004097          	auipc	ra,0x4
    80001c02:	682080e7          	jalr	1666(ra) # 80006280 <acquire>
  ticks++;
    80001c06:	00007517          	auipc	a0,0x7
    80001c0a:	cf250513          	addi	a0,a0,-782 # 800088f8 <ticks>
    80001c0e:	411c                	lw	a5,0(a0)
    80001c10:	2785                	addiw	a5,a5,1
    80001c12:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	97e080e7          	jalr	-1666(ra) # 80001592 <wakeup>
  release(&tickslock);
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	00004097          	auipc	ra,0x4
    80001c22:	716080e7          	jalr	1814(ra) # 80006334 <release>
}
    80001c26:	60e2                	ld	ra,24(sp)
    80001c28:	6442                	ld	s0,16(sp)
    80001c2a:	64a2                	ld	s1,8(sp)
    80001c2c:	6105                	addi	sp,sp,32
    80001c2e:	8082                	ret

0000000080001c30 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c30:	1101                	addi	sp,sp,-32
    80001c32:	ec06                	sd	ra,24(sp)
    80001c34:	e822                	sd	s0,16(sp)
    80001c36:	e426                	sd	s1,8(sp)
    80001c38:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c3a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c3e:	00074d63          	bltz	a4,80001c58 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c42:	57fd                	li	a5,-1
    80001c44:	17fe                	slli	a5,a5,0x3f
    80001c46:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c48:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c4a:	06f70363          	beq	a4,a5,80001cb0 <devintr+0x80>
  }
}
    80001c4e:	60e2                	ld	ra,24(sp)
    80001c50:	6442                	ld	s0,16(sp)
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret
     (scause & 0xff) == 9){
    80001c58:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c5c:	46a5                	li	a3,9
    80001c5e:	fed792e3          	bne	a5,a3,80001c42 <devintr+0x12>
    int irq = plic_claim();
    80001c62:	00003097          	auipc	ra,0x3
    80001c66:	5d6080e7          	jalr	1494(ra) # 80005238 <plic_claim>
    80001c6a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c6c:	47a9                	li	a5,10
    80001c6e:	02f50763          	beq	a0,a5,80001c9c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c72:	4785                	li	a5,1
    80001c74:	02f50963          	beq	a0,a5,80001ca6 <devintr+0x76>
    return 1;
    80001c78:	4505                	li	a0,1
    } else if(irq){
    80001c7a:	d8f1                	beqz	s1,80001c4e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c7c:	85a6                	mv	a1,s1
    80001c7e:	00006517          	auipc	a0,0x6
    80001c82:	60250513          	addi	a0,a0,1538 # 80008280 <states.0+0x38>
    80001c86:	00004097          	auipc	ra,0x4
    80001c8a:	0c0080e7          	jalr	192(ra) # 80005d46 <printf>
      plic_complete(irq);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	00003097          	auipc	ra,0x3
    80001c94:	5cc080e7          	jalr	1484(ra) # 8000525c <plic_complete>
    return 1;
    80001c98:	4505                	li	a0,1
    80001c9a:	bf55                	j	80001c4e <devintr+0x1e>
      uartintr();
    80001c9c:	00004097          	auipc	ra,0x4
    80001ca0:	504080e7          	jalr	1284(ra) # 800061a0 <uartintr>
    80001ca4:	b7ed                	j	80001c8e <devintr+0x5e>
      virtio_disk_intr();
    80001ca6:	00004097          	auipc	ra,0x4
    80001caa:	a7e080e7          	jalr	-1410(ra) # 80005724 <virtio_disk_intr>
    80001cae:	b7c5                	j	80001c8e <devintr+0x5e>
    if(cpuid() == 0){
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	176080e7          	jalr	374(ra) # 80000e26 <cpuid>
    80001cb8:	c901                	beqz	a0,80001cc8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cba:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cbe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cc0:	14479073          	csrw	sip,a5
    return 2;
    80001cc4:	4509                	li	a0,2
    80001cc6:	b761                	j	80001c4e <devintr+0x1e>
      clockintr();
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	f22080e7          	jalr	-222(ra) # 80001bea <clockintr>
    80001cd0:	b7ed                	j	80001cba <devintr+0x8a>

0000000080001cd2 <usertrap>:
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	e426                	sd	s1,8(sp)
    80001cda:	e04a                	sd	s2,0(sp)
    80001cdc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cde:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce2:	1007f793          	andi	a5,a5,256
    80001ce6:	e3b9                	bnez	a5,80001d2c <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ce8:	00003797          	auipc	a5,0x3
    80001cec:	44878793          	addi	a5,a5,1096 # 80005130 <kernelvec>
    80001cf0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	15e080e7          	jalr	350(ra) # 80000e52 <myproc>
    80001cfc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cfe:	19853783          	ld	a5,408(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d02:	14102773          	csrr	a4,sepc
    80001d06:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d08:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d0c:	47a1                	li	a5,8
    80001d0e:	02f70763          	beq	a4,a5,80001d3c <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	f1e080e7          	jalr	-226(ra) # 80001c30 <devintr>
    80001d1a:	892a                	mv	s2,a0
    80001d1c:	c159                	beqz	a0,80001da2 <usertrap+0xd0>
  if(killed(p))
    80001d1e:	8526                	mv	a0,s1
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	aba080e7          	jalr	-1350(ra) # 800017da <killed>
    80001d28:	c931                	beqz	a0,80001d7c <usertrap+0xaa>
    80001d2a:	a0a1                	j	80001d72 <usertrap+0xa0>
    panic("usertrap: not from user mode");
    80001d2c:	00006517          	auipc	a0,0x6
    80001d30:	57450513          	addi	a0,a0,1396 # 800082a0 <states.0+0x58>
    80001d34:	00004097          	auipc	ra,0x4
    80001d38:	fc8080e7          	jalr	-56(ra) # 80005cfc <panic>
    if(killed(p))
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	a9e080e7          	jalr	-1378(ra) # 800017da <killed>
    80001d44:	e929                	bnez	a0,80001d96 <usertrap+0xc4>
    p->trapframe->epc += 4;
    80001d46:	1984b703          	ld	a4,408(s1)
    80001d4a:	6f1c                	ld	a5,24(a4)
    80001d4c:	0791                	addi	a5,a5,4
    80001d4e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d58:	10079073          	csrw	sstatus,a5
    syscall();
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	346080e7          	jalr	838(ra) # 800020a2 <syscall>
  if(killed(p))
    80001d64:	8526                	mv	a0,s1
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	a74080e7          	jalr	-1420(ra) # 800017da <killed>
    80001d6e:	c911                	beqz	a0,80001d82 <usertrap+0xb0>
    80001d70:	4901                	li	s2,0
    exit(-1);
    80001d72:	557d                	li	a0,-1
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	8f2080e7          	jalr	-1806(ra) # 80001666 <exit>
  if(which_dev == 2)
    80001d7c:	4789                	li	a5,2
    80001d7e:	04f90f63          	beq	s2,a5,80001ddc <usertrap+0x10a>
  usertrapret();
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	dc4080e7          	jalr	-572(ra) # 80001b46 <usertrapret>
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6902                	ld	s2,0(sp)
    80001d92:	6105                	addi	sp,sp,32
    80001d94:	8082                	ret
      exit(-1);
    80001d96:	557d                	li	a0,-1
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	8ce080e7          	jalr	-1842(ra) # 80001666 <exit>
    80001da0:	b75d                	j	80001d46 <usertrap+0x74>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001da6:	5890                	lw	a2,48(s1)
    80001da8:	00006517          	auipc	a0,0x6
    80001dac:	51850513          	addi	a0,a0,1304 # 800082c0 <states.0+0x78>
    80001db0:	00004097          	auipc	ra,0x4
    80001db4:	f96080e7          	jalr	-106(ra) # 80005d46 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dbc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	53050513          	addi	a0,a0,1328 # 800082f0 <states.0+0xa8>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	f7e080e7          	jalr	-130(ra) # 80005d46 <printf>
    setkilled(p);
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	9dc080e7          	jalr	-1572(ra) # 800017ae <setkilled>
    80001dda:	b769                	j	80001d64 <usertrap+0x92>
    struct proc* proc = myproc();
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	076080e7          	jalr	118(ra) # 80000e52 <myproc>
    if(proc->alarm_interval && proc->have_return)
    80001de4:	413c                	lw	a5,64(a0)
    80001de6:	cf81                	beqz	a5,80001dfe <usertrap+0x12c>
    80001de8:	16852783          	lw	a5,360(a0)
    80001dec:	cb89                	beqz	a5,80001dfe <usertrap+0x12c>
      if(++proc->passed_ticked == 2)
    80001dee:	417c                	lw	a5,68(a0)
    80001df0:	2785                	addiw	a5,a5,1
    80001df2:	0007871b          	sext.w	a4,a5
    80001df6:	c17c                	sw	a5,68(a0)
    80001df8:	4789                	li	a5,2
    80001dfa:	00f70763          	beq	a4,a5,80001e08 <usertrap+0x136>
    yield();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	6f4080e7          	jalr	1780(ra) # 800014f2 <yield>
    80001e06:	bfb5                	j	80001d82 <usertrap+0xb0>
        proc->saved_trapframe = *proc->trapframe;
    80001e08:	19853883          	ld	a7,408(a0)
    80001e0c:	87c6                	mv	a5,a7
    80001e0e:	04850713          	addi	a4,a0,72
    80001e12:	12088313          	addi	t1,a7,288
    80001e16:	0007b803          	ld	a6,0(a5)
    80001e1a:	678c                	ld	a1,8(a5)
    80001e1c:	6b90                	ld	a2,16(a5)
    80001e1e:	6f94                	ld	a3,24(a5)
    80001e20:	01073023          	sd	a6,0(a4)
    80001e24:	e70c                	sd	a1,8(a4)
    80001e26:	eb10                	sd	a2,16(a4)
    80001e28:	ef14                	sd	a3,24(a4)
    80001e2a:	02078793          	addi	a5,a5,32
    80001e2e:	02070713          	addi	a4,a4,32
    80001e32:	fe6792e3          	bne	a5,t1,80001e16 <usertrap+0x144>
        proc->trapframe->epc = proc->handler_va;
    80001e36:	7d1c                	ld	a5,56(a0)
    80001e38:	00f8bc23          	sd	a5,24(a7)
        proc->passed_ticked = 0;
    80001e3c:	04052223          	sw	zero,68(a0)
        proc->have_return = 0;
    80001e40:	16052423          	sw	zero,360(a0)
    80001e44:	bf6d                	j	80001dfe <usertrap+0x12c>

0000000080001e46 <kerneltrap>:
{
    80001e46:	7179                	addi	sp,sp,-48
    80001e48:	f406                	sd	ra,40(sp)
    80001e4a:	f022                	sd	s0,32(sp)
    80001e4c:	ec26                	sd	s1,24(sp)
    80001e4e:	e84a                	sd	s2,16(sp)
    80001e50:	e44e                	sd	s3,8(sp)
    80001e52:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e54:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e58:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e60:	1004f793          	andi	a5,s1,256
    80001e64:	cb85                	beqz	a5,80001e94 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e66:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e6a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e6c:	ef85                	bnez	a5,80001ea4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e6e:	00000097          	auipc	ra,0x0
    80001e72:	dc2080e7          	jalr	-574(ra) # 80001c30 <devintr>
    80001e76:	cd1d                	beqz	a0,80001eb4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e78:	4789                	li	a5,2
    80001e7a:	06f50a63          	beq	a0,a5,80001eee <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e7e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e82:	10049073          	csrw	sstatus,s1
}
    80001e86:	70a2                	ld	ra,40(sp)
    80001e88:	7402                	ld	s0,32(sp)
    80001e8a:	64e2                	ld	s1,24(sp)
    80001e8c:	6942                	ld	s2,16(sp)
    80001e8e:	69a2                	ld	s3,8(sp)
    80001e90:	6145                	addi	sp,sp,48
    80001e92:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e94:	00006517          	auipc	a0,0x6
    80001e98:	47c50513          	addi	a0,a0,1148 # 80008310 <states.0+0xc8>
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	e60080e7          	jalr	-416(ra) # 80005cfc <panic>
    panic("kerneltrap: interrupts enabled");
    80001ea4:	00006517          	auipc	a0,0x6
    80001ea8:	49450513          	addi	a0,a0,1172 # 80008338 <states.0+0xf0>
    80001eac:	00004097          	auipc	ra,0x4
    80001eb0:	e50080e7          	jalr	-432(ra) # 80005cfc <panic>
    printf("scause %p\n", scause);
    80001eb4:	85ce                	mv	a1,s3
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	4a250513          	addi	a0,a0,1186 # 80008358 <states.0+0x110>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	e88080e7          	jalr	-376(ra) # 80005d46 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eca:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ece:	00006517          	auipc	a0,0x6
    80001ed2:	49a50513          	addi	a0,a0,1178 # 80008368 <states.0+0x120>
    80001ed6:	00004097          	auipc	ra,0x4
    80001eda:	e70080e7          	jalr	-400(ra) # 80005d46 <printf>
    panic("kerneltrap");
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	4a250513          	addi	a0,a0,1186 # 80008380 <states.0+0x138>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	e16080e7          	jalr	-490(ra) # 80005cfc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	f64080e7          	jalr	-156(ra) # 80000e52 <myproc>
    80001ef6:	d541                	beqz	a0,80001e7e <kerneltrap+0x38>
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	f5a080e7          	jalr	-166(ra) # 80000e52 <myproc>
    80001f00:	4d18                	lw	a4,24(a0)
    80001f02:	4791                	li	a5,4
    80001f04:	f6f71de3          	bne	a4,a5,80001e7e <kerneltrap+0x38>
    yield();
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	5ea080e7          	jalr	1514(ra) # 800014f2 <yield>
    80001f10:	b7bd                	j	80001e7e <kerneltrap+0x38>

0000000080001f12 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f12:	1101                	addi	sp,sp,-32
    80001f14:	ec06                	sd	ra,24(sp)
    80001f16:	e822                	sd	s0,16(sp)
    80001f18:	e426                	sd	s1,8(sp)
    80001f1a:	1000                	addi	s0,sp,32
    80001f1c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	f34080e7          	jalr	-204(ra) # 80000e52 <myproc>
  switch (n) {
    80001f26:	4795                	li	a5,5
    80001f28:	0497e763          	bltu	a5,s1,80001f76 <argraw+0x64>
    80001f2c:	048a                	slli	s1,s1,0x2
    80001f2e:	00006717          	auipc	a4,0x6
    80001f32:	48a70713          	addi	a4,a4,1162 # 800083b8 <states.0+0x170>
    80001f36:	94ba                	add	s1,s1,a4
    80001f38:	409c                	lw	a5,0(s1)
    80001f3a:	97ba                	add	a5,a5,a4
    80001f3c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f3e:	19853783          	ld	a5,408(a0)
    80001f42:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f44:	60e2                	ld	ra,24(sp)
    80001f46:	6442                	ld	s0,16(sp)
    80001f48:	64a2                	ld	s1,8(sp)
    80001f4a:	6105                	addi	sp,sp,32
    80001f4c:	8082                	ret
    return p->trapframe->a1;
    80001f4e:	19853783          	ld	a5,408(a0)
    80001f52:	7fa8                	ld	a0,120(a5)
    80001f54:	bfc5                	j	80001f44 <argraw+0x32>
    return p->trapframe->a2;
    80001f56:	19853783          	ld	a5,408(a0)
    80001f5a:	63c8                	ld	a0,128(a5)
    80001f5c:	b7e5                	j	80001f44 <argraw+0x32>
    return p->trapframe->a3;
    80001f5e:	19853783          	ld	a5,408(a0)
    80001f62:	67c8                	ld	a0,136(a5)
    80001f64:	b7c5                	j	80001f44 <argraw+0x32>
    return p->trapframe->a4;
    80001f66:	19853783          	ld	a5,408(a0)
    80001f6a:	6bc8                	ld	a0,144(a5)
    80001f6c:	bfe1                	j	80001f44 <argraw+0x32>
    return p->trapframe->a5;
    80001f6e:	19853783          	ld	a5,408(a0)
    80001f72:	6fc8                	ld	a0,152(a5)
    80001f74:	bfc1                	j	80001f44 <argraw+0x32>
  panic("argraw");
    80001f76:	00006517          	auipc	a0,0x6
    80001f7a:	41a50513          	addi	a0,a0,1050 # 80008390 <states.0+0x148>
    80001f7e:	00004097          	auipc	ra,0x4
    80001f82:	d7e080e7          	jalr	-642(ra) # 80005cfc <panic>

0000000080001f86 <fetchaddr>:
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	e04a                	sd	s2,0(sp)
    80001f90:	1000                	addi	s0,sp,32
    80001f92:	84aa                	mv	s1,a0
    80001f94:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	ebc080e7          	jalr	-324(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f9e:	18053783          	ld	a5,384(a0)
    80001fa2:	02f4f963          	bgeu	s1,a5,80001fd4 <fetchaddr+0x4e>
    80001fa6:	00848713          	addi	a4,s1,8
    80001faa:	02e7e763          	bltu	a5,a4,80001fd8 <fetchaddr+0x52>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fae:	46a1                	li	a3,8
    80001fb0:	8626                	mv	a2,s1
    80001fb2:	85ca                	mv	a1,s2
    80001fb4:	18853503          	ld	a0,392(a0)
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	be8080e7          	jalr	-1048(ra) # 80000ba0 <copyin>
    80001fc0:	00a03533          	snez	a0,a0
    80001fc4:	40a00533          	neg	a0,a0
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret
    return -1;
    80001fd4:	557d                	li	a0,-1
    80001fd6:	bfcd                	j	80001fc8 <fetchaddr+0x42>
    80001fd8:	557d                	li	a0,-1
    80001fda:	b7fd                	j	80001fc8 <fetchaddr+0x42>

0000000080001fdc <fetchstr>:
{
    80001fdc:	7179                	addi	sp,sp,-48
    80001fde:	f406                	sd	ra,40(sp)
    80001fe0:	f022                	sd	s0,32(sp)
    80001fe2:	ec26                	sd	s1,24(sp)
    80001fe4:	e84a                	sd	s2,16(sp)
    80001fe6:	e44e                	sd	s3,8(sp)
    80001fe8:	1800                	addi	s0,sp,48
    80001fea:	892a                	mv	s2,a0
    80001fec:	84ae                	mv	s1,a1
    80001fee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	e62080e7          	jalr	-414(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ff8:	86ce                	mv	a3,s3
    80001ffa:	864a                	mv	a2,s2
    80001ffc:	85a6                	mv	a1,s1
    80001ffe:	18853503          	ld	a0,392(a0)
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	c2c080e7          	jalr	-980(ra) # 80000c2e <copyinstr>
    8000200a:	00054e63          	bltz	a0,80002026 <fetchstr+0x4a>
  return strlen(buf);
    8000200e:	8526                	mv	a0,s1
    80002010:	ffffe097          	auipc	ra,0xffffe
    80002014:	2e6080e7          	jalr	742(ra) # 800002f6 <strlen>
}
    80002018:	70a2                	ld	ra,40(sp)
    8000201a:	7402                	ld	s0,32(sp)
    8000201c:	64e2                	ld	s1,24(sp)
    8000201e:	6942                	ld	s2,16(sp)
    80002020:	69a2                	ld	s3,8(sp)
    80002022:	6145                	addi	sp,sp,48
    80002024:	8082                	ret
    return -1;
    80002026:	557d                	li	a0,-1
    80002028:	bfc5                	j	80002018 <fetchstr+0x3c>

000000008000202a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000202a:	1101                	addi	sp,sp,-32
    8000202c:	ec06                	sd	ra,24(sp)
    8000202e:	e822                	sd	s0,16(sp)
    80002030:	e426                	sd	s1,8(sp)
    80002032:	1000                	addi	s0,sp,32
    80002034:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	edc080e7          	jalr	-292(ra) # 80001f12 <argraw>
    8000203e:	c088                	sw	a0,0(s1)
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	e426                	sd	s1,8(sp)
    80002052:	1000                	addi	s0,sp,32
    80002054:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	ebc080e7          	jalr	-324(ra) # 80001f12 <argraw>
    8000205e:	e088                	sd	a0,0(s1)
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	1800                	addi	s0,sp,48
    80002076:	84ae                	mv	s1,a1
    80002078:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000207a:	fd840593          	addi	a1,s0,-40
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	fcc080e7          	jalr	-52(ra) # 8000204a <argaddr>
  return fetchstr(addr, buf, max);
    80002086:	864a                	mv	a2,s2
    80002088:	85a6                	mv	a1,s1
    8000208a:	fd843503          	ld	a0,-40(s0)
    8000208e:	00000097          	auipc	ra,0x0
    80002092:	f4e080e7          	jalr	-178(ra) # 80001fdc <fetchstr>
}
    80002096:	70a2                	ld	ra,40(sp)
    80002098:	7402                	ld	s0,32(sp)
    8000209a:	64e2                	ld	s1,24(sp)
    8000209c:	6942                	ld	s2,16(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret

00000000800020a2 <syscall>:



void
syscall(void)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	e04a                	sd	s2,0(sp)
    800020ac:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	da4080e7          	jalr	-604(ra) # 80000e52 <myproc>
    800020b6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020b8:	19853903          	ld	s2,408(a0)
    800020bc:	0a893783          	ld	a5,168(s2)
    800020c0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020c4:	37fd                	addiw	a5,a5,-1
    800020c6:	4761                	li	a4,24
    800020c8:	00f76f63          	bltu	a4,a5,800020e6 <syscall+0x44>
    800020cc:	00369713          	slli	a4,a3,0x3
    800020d0:	00006797          	auipc	a5,0x6
    800020d4:	30078793          	addi	a5,a5,768 # 800083d0 <syscalls>
    800020d8:	97ba                	add	a5,a5,a4
    800020da:	639c                	ld	a5,0(a5)
    800020dc:	c789                	beqz	a5,800020e6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020de:	9782                	jalr	a5
    800020e0:	06a93823          	sd	a0,112(s2)
    800020e4:	a005                	j	80002104 <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020e6:	29848613          	addi	a2,s1,664
    800020ea:	588c                	lw	a1,48(s1)
    800020ec:	00006517          	auipc	a0,0x6
    800020f0:	2ac50513          	addi	a0,a0,684 # 80008398 <states.0+0x150>
    800020f4:	00004097          	auipc	ra,0x4
    800020f8:	c52080e7          	jalr	-942(ra) # 80005d46 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020fc:	1984b783          	ld	a5,408(s1)
    80002100:	577d                	li	a4,-1
    80002102:	fbb8                	sd	a4,112(a5)
  }
}
    80002104:	60e2                	ld	ra,24(sp)
    80002106:	6442                	ld	s0,16(sp)
    80002108:	64a2                	ld	s1,8(sp)
    8000210a:	6902                	ld	s2,0(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002118:	fec40593          	addi	a1,s0,-20
    8000211c:	4501                	li	a0,0
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	f0c080e7          	jalr	-244(ra) # 8000202a <argint>
  exit(n);
    80002126:	fec42503          	lw	a0,-20(s0)
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	53c080e7          	jalr	1340(ra) # 80001666 <exit>
  return 0;  // not reached
}
    80002132:	4501                	li	a0,0
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret

000000008000213c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000213c:	1141                	addi	sp,sp,-16
    8000213e:	e406                	sd	ra,8(sp)
    80002140:	e022                	sd	s0,0(sp)
    80002142:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	d0e080e7          	jalr	-754(ra) # 80000e52 <myproc>
}
    8000214c:	5908                	lw	a0,48(a0)
    8000214e:	60a2                	ld	ra,8(sp)
    80002150:	6402                	ld	s0,0(sp)
    80002152:	0141                	addi	sp,sp,16
    80002154:	8082                	ret

0000000080002156 <sys_fork>:

uint64
sys_fork(void)
{
    80002156:	1141                	addi	sp,sp,-16
    80002158:	e406                	sd	ra,8(sp)
    8000215a:	e022                	sd	s0,0(sp)
    8000215c:	0800                	addi	s0,sp,16
  return fork();
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	0dc080e7          	jalr	220(ra) # 8000123a <fork>
}
    80002166:	60a2                	ld	ra,8(sp)
    80002168:	6402                	ld	s0,0(sp)
    8000216a:	0141                	addi	sp,sp,16
    8000216c:	8082                	ret

000000008000216e <sys_wait>:

uint64
sys_wait(void)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002176:	fe840593          	addi	a1,s0,-24
    8000217a:	4501                	li	a0,0
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	ece080e7          	jalr	-306(ra) # 8000204a <argaddr>
  return wait(p);
    80002184:	fe843503          	ld	a0,-24(s0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	684080e7          	jalr	1668(ra) # 8000180c <wait>
}
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002198:	7179                	addi	sp,sp,-48
    8000219a:	f406                	sd	ra,40(sp)
    8000219c:	f022                	sd	s0,32(sp)
    8000219e:	ec26                	sd	s1,24(sp)
    800021a0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021a2:	fdc40593          	addi	a1,s0,-36
    800021a6:	4501                	li	a0,0
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	e82080e7          	jalr	-382(ra) # 8000202a <argint>
  addr = myproc()->sz;
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	ca2080e7          	jalr	-862(ra) # 80000e52 <myproc>
    800021b8:	18053483          	ld	s1,384(a0)
  if(growproc(n) < 0)
    800021bc:	fdc42503          	lw	a0,-36(s0)
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	016080e7          	jalr	22(ra) # 800011d6 <growproc>
    800021c8:	00054863          	bltz	a0,800021d8 <sys_sbrk+0x40>
    return -1;
  return addr;
}
    800021cc:	8526                	mv	a0,s1
    800021ce:	70a2                	ld	ra,40(sp)
    800021d0:	7402                	ld	s0,32(sp)
    800021d2:	64e2                	ld	s1,24(sp)
    800021d4:	6145                	addi	sp,sp,48
    800021d6:	8082                	ret
    return -1;
    800021d8:	54fd                	li	s1,-1
    800021da:	bfcd                	j	800021cc <sys_sbrk+0x34>

00000000800021dc <sys_sleep>:

uint64
sys_sleep(void)
{
    800021dc:	7139                	addi	sp,sp,-64
    800021de:	fc06                	sd	ra,56(sp)
    800021e0:	f822                	sd	s0,48(sp)
    800021e2:	f426                	sd	s1,40(sp)
    800021e4:	f04a                	sd	s2,32(sp)
    800021e6:	ec4e                	sd	s3,24(sp)
    800021e8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  backtrace();
    800021ea:	00004097          	auipc	ra,0x4
    800021ee:	d6e080e7          	jalr	-658(ra) # 80005f58 <backtrace>

  argint(0, &n);
    800021f2:	fcc40593          	addi	a1,s0,-52
    800021f6:	4501                	li	a0,0
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	e32080e7          	jalr	-462(ra) # 8000202a <argint>
  acquire(&tickslock);
    80002200:	00011517          	auipc	a0,0x11
    80002204:	56050513          	addi	a0,a0,1376 # 80013760 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	078080e7          	jalr	120(ra) # 80006280 <acquire>
  ticks0 = ticks;
    80002210:	00006917          	auipc	s2,0x6
    80002214:	6e892903          	lw	s2,1768(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    80002218:	fcc42783          	lw	a5,-52(s0)
    8000221c:	cf9d                	beqz	a5,8000225a <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000221e:	00011997          	auipc	s3,0x11
    80002222:	54298993          	addi	s3,s3,1346 # 80013760 <tickslock>
    80002226:	00006497          	auipc	s1,0x6
    8000222a:	6d248493          	addi	s1,s1,1746 # 800088f8 <ticks>
    if(killed(myproc())){
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	c24080e7          	jalr	-988(ra) # 80000e52 <myproc>
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	5a4080e7          	jalr	1444(ra) # 800017da <killed>
    8000223e:	ed15                	bnez	a0,8000227a <sys_sleep+0x9e>
    sleep(&ticks, &tickslock);
    80002240:	85ce                	mv	a1,s3
    80002242:	8526                	mv	a0,s1
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	2ea080e7          	jalr	746(ra) # 8000152e <sleep>
  while(ticks - ticks0 < n){
    8000224c:	409c                	lw	a5,0(s1)
    8000224e:	412787bb          	subw	a5,a5,s2
    80002252:	fcc42703          	lw	a4,-52(s0)
    80002256:	fce7ece3          	bltu	a5,a4,8000222e <sys_sleep+0x52>
  }
  release(&tickslock);
    8000225a:	00011517          	auipc	a0,0x11
    8000225e:	50650513          	addi	a0,a0,1286 # 80013760 <tickslock>
    80002262:	00004097          	auipc	ra,0x4
    80002266:	0d2080e7          	jalr	210(ra) # 80006334 <release>
  return 0;
    8000226a:	4501                	li	a0,0
}
    8000226c:	70e2                	ld	ra,56(sp)
    8000226e:	7442                	ld	s0,48(sp)
    80002270:	74a2                	ld	s1,40(sp)
    80002272:	7902                	ld	s2,32(sp)
    80002274:	69e2                	ld	s3,24(sp)
    80002276:	6121                	addi	sp,sp,64
    80002278:	8082                	ret
      release(&tickslock);
    8000227a:	00011517          	auipc	a0,0x11
    8000227e:	4e650513          	addi	a0,a0,1254 # 80013760 <tickslock>
    80002282:	00004097          	auipc	ra,0x4
    80002286:	0b2080e7          	jalr	178(ra) # 80006334 <release>
      return -1;
    8000228a:	557d                	li	a0,-1
    8000228c:	b7c5                	j	8000226c <sys_sleep+0x90>

000000008000228e <sys_kill>:
}
#endif

uint64
sys_kill(void)
{
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002296:	fec40593          	addi	a1,s0,-20
    8000229a:	4501                	li	a0,0
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	d8e080e7          	jalr	-626(ra) # 8000202a <argint>
  return kill(pid);
    800022a4:	fec42503          	lw	a0,-20(s0)
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	494080e7          	jalr	1172(ra) # 8000173c <kill>
}
    800022b0:	60e2                	ld	ra,24(sp)
    800022b2:	6442                	ld	s0,16(sp)
    800022b4:	6105                	addi	sp,sp,32
    800022b6:	8082                	ret

00000000800022b8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022b8:	1101                	addi	sp,sp,-32
    800022ba:	ec06                	sd	ra,24(sp)
    800022bc:	e822                	sd	s0,16(sp)
    800022be:	e426                	sd	s1,8(sp)
    800022c0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022c2:	00011517          	auipc	a0,0x11
    800022c6:	49e50513          	addi	a0,a0,1182 # 80013760 <tickslock>
    800022ca:	00004097          	auipc	ra,0x4
    800022ce:	fb6080e7          	jalr	-74(ra) # 80006280 <acquire>
  xticks = ticks;
    800022d2:	00006497          	auipc	s1,0x6
    800022d6:	6264a483          	lw	s1,1574(s1) # 800088f8 <ticks>
  release(&tickslock);
    800022da:	00011517          	auipc	a0,0x11
    800022de:	48650513          	addi	a0,a0,1158 # 80013760 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	052080e7          	jalr	82(ra) # 80006334 <release>
  return xticks;
}
    800022ea:	02049513          	slli	a0,s1,0x20
    800022ee:	9101                	srli	a0,a0,0x20
    800022f0:	60e2                	ld	ra,24(sp)
    800022f2:	6442                	ld	s0,16(sp)
    800022f4:	64a2                	ld	s1,8(sp)
    800022f6:	6105                	addi	sp,sp,32
    800022f8:	8082                	ret

00000000800022fa <sys_sigalarm>:

uint64 sys_sigalarm()
{
    800022fa:	1101                	addi	sp,sp,-32
    800022fc:	ec06                	sd	ra,24(sp)
    800022fe:	e822                	sd	s0,16(sp)
    80002300:	1000                	addi	s0,sp,32
  int ticks;
  uint64 handler_va;

  argint(0, &ticks);
    80002302:	fec40593          	addi	a1,s0,-20
    80002306:	4501                	li	a0,0
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	d22080e7          	jalr	-734(ra) # 8000202a <argint>
  argaddr(1, &handler_va);
    80002310:	fe040593          	addi	a1,s0,-32
    80002314:	4505                	li	a0,1
    80002316:	00000097          	auipc	ra,0x0
    8000231a:	d34080e7          	jalr	-716(ra) # 8000204a <argaddr>
  struct proc* proc = myproc();
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	b34080e7          	jalr	-1228(ra) # 80000e52 <myproc>

  proc->alarm_interval = ticks;
    80002326:	fec42783          	lw	a5,-20(s0)
    8000232a:	c13c                	sw	a5,64(a0)
  proc->handler_va = handler_va;
    8000232c:	fe043783          	ld	a5,-32(s0)
    80002330:	fd1c                	sd	a5,56(a0)
  proc->have_return = 1;
    80002332:	4785                	li	a5,1
    80002334:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002338:	4501                	li	a0,0
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_sigreturn>:

uint64 sys_sigreturn()
{
    80002342:	1141                	addi	sp,sp,-16
    80002344:	e406                	sd	ra,8(sp)
    80002346:	e022                	sd	s0,0(sp)
    80002348:	0800                	addi	s0,sp,16
  struct proc* proc = myproc();
    8000234a:	fffff097          	auipc	ra,0xfffff
    8000234e:	b08080e7          	jalr	-1272(ra) # 80000e52 <myproc>

  *proc->trapframe = proc->saved_trapframe;
    80002352:	04850793          	addi	a5,a0,72
    80002356:	19853703          	ld	a4,408(a0)
    8000235a:	16850693          	addi	a3,a0,360
    8000235e:	0007b883          	ld	a7,0(a5)
    80002362:	0087b803          	ld	a6,8(a5)
    80002366:	6b8c                	ld	a1,16(a5)
    80002368:	6f90                	ld	a2,24(a5)
    8000236a:	01173023          	sd	a7,0(a4)
    8000236e:	01073423          	sd	a6,8(a4)
    80002372:	eb0c                	sd	a1,16(a4)
    80002374:	ef10                	sd	a2,24(a4)
    80002376:	02078793          	addi	a5,a5,32
    8000237a:	02070713          	addi	a4,a4,32
    8000237e:	fed790e3          	bne	a5,a3,8000235e <sys_sigreturn+0x1c>
  proc->have_return = 1;
    80002382:	4785                	li	a5,1
    80002384:	16f52423          	sw	a5,360(a0)
  return proc->trapframe->a0;
    80002388:	19853783          	ld	a5,408(a0)
}
    8000238c:	7ba8                	ld	a0,112(a5)
    8000238e:	60a2                	ld	ra,8(sp)
    80002390:	6402                	ld	s0,0(sp)
    80002392:	0141                	addi	sp,sp,16
    80002394:	8082                	ret

0000000080002396 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002396:	7179                	addi	sp,sp,-48
    80002398:	f406                	sd	ra,40(sp)
    8000239a:	f022                	sd	s0,32(sp)
    8000239c:	ec26                	sd	s1,24(sp)
    8000239e:	e84a                	sd	s2,16(sp)
    800023a0:	e44e                	sd	s3,8(sp)
    800023a2:	e052                	sd	s4,0(sp)
    800023a4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023a6:	00006597          	auipc	a1,0x6
    800023aa:	0fa58593          	addi	a1,a1,250 # 800084a0 <syscalls+0xd0>
    800023ae:	00011517          	auipc	a0,0x11
    800023b2:	3ca50513          	addi	a0,a0,970 # 80013778 <bcache>
    800023b6:	00004097          	auipc	ra,0x4
    800023ba:	e3a080e7          	jalr	-454(ra) # 800061f0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023be:	00019797          	auipc	a5,0x19
    800023c2:	3ba78793          	addi	a5,a5,954 # 8001b778 <bcache+0x8000>
    800023c6:	00019717          	auipc	a4,0x19
    800023ca:	61a70713          	addi	a4,a4,1562 # 8001b9e0 <bcache+0x8268>
    800023ce:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023d2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d6:	00011497          	auipc	s1,0x11
    800023da:	3ba48493          	addi	s1,s1,954 # 80013790 <bcache+0x18>
    b->next = bcache.head.next;
    800023de:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023e0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023e2:	00006a17          	auipc	s4,0x6
    800023e6:	0c6a0a13          	addi	s4,s4,198 # 800084a8 <syscalls+0xd8>
    b->next = bcache.head.next;
    800023ea:	2b893783          	ld	a5,696(s2)
    800023ee:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023f0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023f4:	85d2                	mv	a1,s4
    800023f6:	01048513          	addi	a0,s1,16
    800023fa:	00001097          	auipc	ra,0x1
    800023fe:	4c8080e7          	jalr	1224(ra) # 800038c2 <initsleeplock>
    bcache.head.next->prev = b;
    80002402:	2b893783          	ld	a5,696(s2)
    80002406:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002408:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000240c:	45848493          	addi	s1,s1,1112
    80002410:	fd349de3          	bne	s1,s3,800023ea <binit+0x54>
  }
}
    80002414:	70a2                	ld	ra,40(sp)
    80002416:	7402                	ld	s0,32(sp)
    80002418:	64e2                	ld	s1,24(sp)
    8000241a:	6942                	ld	s2,16(sp)
    8000241c:	69a2                	ld	s3,8(sp)
    8000241e:	6a02                	ld	s4,0(sp)
    80002420:	6145                	addi	sp,sp,48
    80002422:	8082                	ret

0000000080002424 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002424:	7179                	addi	sp,sp,-48
    80002426:	f406                	sd	ra,40(sp)
    80002428:	f022                	sd	s0,32(sp)
    8000242a:	ec26                	sd	s1,24(sp)
    8000242c:	e84a                	sd	s2,16(sp)
    8000242e:	e44e                	sd	s3,8(sp)
    80002430:	1800                	addi	s0,sp,48
    80002432:	892a                	mv	s2,a0
    80002434:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002436:	00011517          	auipc	a0,0x11
    8000243a:	34250513          	addi	a0,a0,834 # 80013778 <bcache>
    8000243e:	00004097          	auipc	ra,0x4
    80002442:	e42080e7          	jalr	-446(ra) # 80006280 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002446:	00019497          	auipc	s1,0x19
    8000244a:	5ea4b483          	ld	s1,1514(s1) # 8001ba30 <bcache+0x82b8>
    8000244e:	00019797          	auipc	a5,0x19
    80002452:	59278793          	addi	a5,a5,1426 # 8001b9e0 <bcache+0x8268>
    80002456:	02f48f63          	beq	s1,a5,80002494 <bread+0x70>
    8000245a:	873e                	mv	a4,a5
    8000245c:	a021                	j	80002464 <bread+0x40>
    8000245e:	68a4                	ld	s1,80(s1)
    80002460:	02e48a63          	beq	s1,a4,80002494 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002464:	449c                	lw	a5,8(s1)
    80002466:	ff279ce3          	bne	a5,s2,8000245e <bread+0x3a>
    8000246a:	44dc                	lw	a5,12(s1)
    8000246c:	ff3799e3          	bne	a5,s3,8000245e <bread+0x3a>
      b->refcnt++;
    80002470:	40bc                	lw	a5,64(s1)
    80002472:	2785                	addiw	a5,a5,1
    80002474:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002476:	00011517          	auipc	a0,0x11
    8000247a:	30250513          	addi	a0,a0,770 # 80013778 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	eb6080e7          	jalr	-330(ra) # 80006334 <release>
      acquiresleep(&b->lock);
    80002486:	01048513          	addi	a0,s1,16
    8000248a:	00001097          	auipc	ra,0x1
    8000248e:	472080e7          	jalr	1138(ra) # 800038fc <acquiresleep>
      return b;
    80002492:	a8b9                	j	800024f0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002494:	00019497          	auipc	s1,0x19
    80002498:	5944b483          	ld	s1,1428(s1) # 8001ba28 <bcache+0x82b0>
    8000249c:	00019797          	auipc	a5,0x19
    800024a0:	54478793          	addi	a5,a5,1348 # 8001b9e0 <bcache+0x8268>
    800024a4:	00f48863          	beq	s1,a5,800024b4 <bread+0x90>
    800024a8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024aa:	40bc                	lw	a5,64(s1)
    800024ac:	cf81                	beqz	a5,800024c4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024ae:	64a4                	ld	s1,72(s1)
    800024b0:	fee49de3          	bne	s1,a4,800024aa <bread+0x86>
  panic("bget: no buffers");
    800024b4:	00006517          	auipc	a0,0x6
    800024b8:	ffc50513          	addi	a0,a0,-4 # 800084b0 <syscalls+0xe0>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	840080e7          	jalr	-1984(ra) # 80005cfc <panic>
      b->dev = dev;
    800024c4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024c8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024cc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024d0:	4785                	li	a5,1
    800024d2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024d4:	00011517          	auipc	a0,0x11
    800024d8:	2a450513          	addi	a0,a0,676 # 80013778 <bcache>
    800024dc:	00004097          	auipc	ra,0x4
    800024e0:	e58080e7          	jalr	-424(ra) # 80006334 <release>
      acquiresleep(&b->lock);
    800024e4:	01048513          	addi	a0,s1,16
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	414080e7          	jalr	1044(ra) # 800038fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024f0:	409c                	lw	a5,0(s1)
    800024f2:	cb89                	beqz	a5,80002504 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024f4:	8526                	mv	a0,s1
    800024f6:	70a2                	ld	ra,40(sp)
    800024f8:	7402                	ld	s0,32(sp)
    800024fa:	64e2                	ld	s1,24(sp)
    800024fc:	6942                	ld	s2,16(sp)
    800024fe:	69a2                	ld	s3,8(sp)
    80002500:	6145                	addi	sp,sp,48
    80002502:	8082                	ret
    virtio_disk_rw(b, 0);
    80002504:	4581                	li	a1,0
    80002506:	8526                	mv	a0,s1
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	fea080e7          	jalr	-22(ra) # 800054f2 <virtio_disk_rw>
    b->valid = 1;
    80002510:	4785                	li	a5,1
    80002512:	c09c                	sw	a5,0(s1)
  return b;
    80002514:	b7c5                	j	800024f4 <bread+0xd0>

0000000080002516 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	e426                	sd	s1,8(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002522:	0541                	addi	a0,a0,16
    80002524:	00001097          	auipc	ra,0x1
    80002528:	472080e7          	jalr	1138(ra) # 80003996 <holdingsleep>
    8000252c:	cd01                	beqz	a0,80002544 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000252e:	4585                	li	a1,1
    80002530:	8526                	mv	a0,s1
    80002532:	00003097          	auipc	ra,0x3
    80002536:	fc0080e7          	jalr	-64(ra) # 800054f2 <virtio_disk_rw>
}
    8000253a:	60e2                	ld	ra,24(sp)
    8000253c:	6442                	ld	s0,16(sp)
    8000253e:	64a2                	ld	s1,8(sp)
    80002540:	6105                	addi	sp,sp,32
    80002542:	8082                	ret
    panic("bwrite");
    80002544:	00006517          	auipc	a0,0x6
    80002548:	f8450513          	addi	a0,a0,-124 # 800084c8 <syscalls+0xf8>
    8000254c:	00003097          	auipc	ra,0x3
    80002550:	7b0080e7          	jalr	1968(ra) # 80005cfc <panic>

0000000080002554 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002554:	1101                	addi	sp,sp,-32
    80002556:	ec06                	sd	ra,24(sp)
    80002558:	e822                	sd	s0,16(sp)
    8000255a:	e426                	sd	s1,8(sp)
    8000255c:	e04a                	sd	s2,0(sp)
    8000255e:	1000                	addi	s0,sp,32
    80002560:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002562:	01050913          	addi	s2,a0,16
    80002566:	854a                	mv	a0,s2
    80002568:	00001097          	auipc	ra,0x1
    8000256c:	42e080e7          	jalr	1070(ra) # 80003996 <holdingsleep>
    80002570:	c92d                	beqz	a0,800025e2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002572:	854a                	mv	a0,s2
    80002574:	00001097          	auipc	ra,0x1
    80002578:	3de080e7          	jalr	990(ra) # 80003952 <releasesleep>

  acquire(&bcache.lock);
    8000257c:	00011517          	auipc	a0,0x11
    80002580:	1fc50513          	addi	a0,a0,508 # 80013778 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	cfc080e7          	jalr	-772(ra) # 80006280 <acquire>
  b->refcnt--;
    8000258c:	40bc                	lw	a5,64(s1)
    8000258e:	37fd                	addiw	a5,a5,-1
    80002590:	0007871b          	sext.w	a4,a5
    80002594:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002596:	eb05                	bnez	a4,800025c6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002598:	68bc                	ld	a5,80(s1)
    8000259a:	64b8                	ld	a4,72(s1)
    8000259c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000259e:	64bc                	ld	a5,72(s1)
    800025a0:	68b8                	ld	a4,80(s1)
    800025a2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025a4:	00019797          	auipc	a5,0x19
    800025a8:	1d478793          	addi	a5,a5,468 # 8001b778 <bcache+0x8000>
    800025ac:	2b87b703          	ld	a4,696(a5)
    800025b0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025b2:	00019717          	auipc	a4,0x19
    800025b6:	42e70713          	addi	a4,a4,1070 # 8001b9e0 <bcache+0x8268>
    800025ba:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025bc:	2b87b703          	ld	a4,696(a5)
    800025c0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025c2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025c6:	00011517          	auipc	a0,0x11
    800025ca:	1b250513          	addi	a0,a0,434 # 80013778 <bcache>
    800025ce:	00004097          	auipc	ra,0x4
    800025d2:	d66080e7          	jalr	-666(ra) # 80006334 <release>
}
    800025d6:	60e2                	ld	ra,24(sp)
    800025d8:	6442                	ld	s0,16(sp)
    800025da:	64a2                	ld	s1,8(sp)
    800025dc:	6902                	ld	s2,0(sp)
    800025de:	6105                	addi	sp,sp,32
    800025e0:	8082                	ret
    panic("brelse");
    800025e2:	00006517          	auipc	a0,0x6
    800025e6:	eee50513          	addi	a0,a0,-274 # 800084d0 <syscalls+0x100>
    800025ea:	00003097          	auipc	ra,0x3
    800025ee:	712080e7          	jalr	1810(ra) # 80005cfc <panic>

00000000800025f2 <bpin>:

void
bpin(struct buf *b) {
    800025f2:	1101                	addi	sp,sp,-32
    800025f4:	ec06                	sd	ra,24(sp)
    800025f6:	e822                	sd	s0,16(sp)
    800025f8:	e426                	sd	s1,8(sp)
    800025fa:	1000                	addi	s0,sp,32
    800025fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fe:	00011517          	auipc	a0,0x11
    80002602:	17a50513          	addi	a0,a0,378 # 80013778 <bcache>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	c7a080e7          	jalr	-902(ra) # 80006280 <acquire>
  b->refcnt++;
    8000260e:	40bc                	lw	a5,64(s1)
    80002610:	2785                	addiw	a5,a5,1
    80002612:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002614:	00011517          	auipc	a0,0x11
    80002618:	16450513          	addi	a0,a0,356 # 80013778 <bcache>
    8000261c:	00004097          	auipc	ra,0x4
    80002620:	d18080e7          	jalr	-744(ra) # 80006334 <release>
}
    80002624:	60e2                	ld	ra,24(sp)
    80002626:	6442                	ld	s0,16(sp)
    80002628:	64a2                	ld	s1,8(sp)
    8000262a:	6105                	addi	sp,sp,32
    8000262c:	8082                	ret

000000008000262e <bunpin>:

void
bunpin(struct buf *b) {
    8000262e:	1101                	addi	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	e426                	sd	s1,8(sp)
    80002636:	1000                	addi	s0,sp,32
    80002638:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000263a:	00011517          	auipc	a0,0x11
    8000263e:	13e50513          	addi	a0,a0,318 # 80013778 <bcache>
    80002642:	00004097          	auipc	ra,0x4
    80002646:	c3e080e7          	jalr	-962(ra) # 80006280 <acquire>
  b->refcnt--;
    8000264a:	40bc                	lw	a5,64(s1)
    8000264c:	37fd                	addiw	a5,a5,-1
    8000264e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002650:	00011517          	auipc	a0,0x11
    80002654:	12850513          	addi	a0,a0,296 # 80013778 <bcache>
    80002658:	00004097          	auipc	ra,0x4
    8000265c:	cdc080e7          	jalr	-804(ra) # 80006334 <release>
}
    80002660:	60e2                	ld	ra,24(sp)
    80002662:	6442                	ld	s0,16(sp)
    80002664:	64a2                	ld	s1,8(sp)
    80002666:	6105                	addi	sp,sp,32
    80002668:	8082                	ret

000000008000266a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000266a:	1101                	addi	sp,sp,-32
    8000266c:	ec06                	sd	ra,24(sp)
    8000266e:	e822                	sd	s0,16(sp)
    80002670:	e426                	sd	s1,8(sp)
    80002672:	e04a                	sd	s2,0(sp)
    80002674:	1000                	addi	s0,sp,32
    80002676:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002678:	00d5d59b          	srliw	a1,a1,0xd
    8000267c:	00019797          	auipc	a5,0x19
    80002680:	7d87a783          	lw	a5,2008(a5) # 8001be54 <sb+0x1c>
    80002684:	9dbd                	addw	a1,a1,a5
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	d9e080e7          	jalr	-610(ra) # 80002424 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000268e:	0074f713          	andi	a4,s1,7
    80002692:	4785                	li	a5,1
    80002694:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002698:	14ce                	slli	s1,s1,0x33
    8000269a:	90d9                	srli	s1,s1,0x36
    8000269c:	00950733          	add	a4,a0,s1
    800026a0:	05874703          	lbu	a4,88(a4)
    800026a4:	00e7f6b3          	and	a3,a5,a4
    800026a8:	c69d                	beqz	a3,800026d6 <bfree+0x6c>
    800026aa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ac:	94aa                	add	s1,s1,a0
    800026ae:	fff7c793          	not	a5,a5
    800026b2:	8f7d                	and	a4,a4,a5
    800026b4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026b8:	00001097          	auipc	ra,0x1
    800026bc:	126080e7          	jalr	294(ra) # 800037de <log_write>
  brelse(bp);
    800026c0:	854a                	mv	a0,s2
    800026c2:	00000097          	auipc	ra,0x0
    800026c6:	e92080e7          	jalr	-366(ra) # 80002554 <brelse>
}
    800026ca:	60e2                	ld	ra,24(sp)
    800026cc:	6442                	ld	s0,16(sp)
    800026ce:	64a2                	ld	s1,8(sp)
    800026d0:	6902                	ld	s2,0(sp)
    800026d2:	6105                	addi	sp,sp,32
    800026d4:	8082                	ret
    panic("freeing free block");
    800026d6:	00006517          	auipc	a0,0x6
    800026da:	e0250513          	addi	a0,a0,-510 # 800084d8 <syscalls+0x108>
    800026de:	00003097          	auipc	ra,0x3
    800026e2:	61e080e7          	jalr	1566(ra) # 80005cfc <panic>

00000000800026e6 <balloc>:
{
    800026e6:	711d                	addi	sp,sp,-96
    800026e8:	ec86                	sd	ra,88(sp)
    800026ea:	e8a2                	sd	s0,80(sp)
    800026ec:	e4a6                	sd	s1,72(sp)
    800026ee:	e0ca                	sd	s2,64(sp)
    800026f0:	fc4e                	sd	s3,56(sp)
    800026f2:	f852                	sd	s4,48(sp)
    800026f4:	f456                	sd	s5,40(sp)
    800026f6:	f05a                	sd	s6,32(sp)
    800026f8:	ec5e                	sd	s7,24(sp)
    800026fa:	e862                	sd	s8,16(sp)
    800026fc:	e466                	sd	s9,8(sp)
    800026fe:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002700:	00019797          	auipc	a5,0x19
    80002704:	73c7a783          	lw	a5,1852(a5) # 8001be3c <sb+0x4>
    80002708:	cff5                	beqz	a5,80002804 <balloc+0x11e>
    8000270a:	8baa                	mv	s7,a0
    8000270c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000270e:	00019b17          	auipc	s6,0x19
    80002712:	72ab0b13          	addi	s6,s6,1834 # 8001be38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002716:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002718:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000271c:	6c89                	lui	s9,0x2
    8000271e:	a061                	j	800027a6 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002720:	97ca                	add	a5,a5,s2
    80002722:	8e55                	or	a2,a2,a3
    80002724:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002728:	854a                	mv	a0,s2
    8000272a:	00001097          	auipc	ra,0x1
    8000272e:	0b4080e7          	jalr	180(ra) # 800037de <log_write>
        brelse(bp);
    80002732:	854a                	mv	a0,s2
    80002734:	00000097          	auipc	ra,0x0
    80002738:	e20080e7          	jalr	-480(ra) # 80002554 <brelse>
  bp = bread(dev, bno);
    8000273c:	85a6                	mv	a1,s1
    8000273e:	855e                	mv	a0,s7
    80002740:	00000097          	auipc	ra,0x0
    80002744:	ce4080e7          	jalr	-796(ra) # 80002424 <bread>
    80002748:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000274a:	40000613          	li	a2,1024
    8000274e:	4581                	li	a1,0
    80002750:	05850513          	addi	a0,a0,88
    80002754:	ffffe097          	auipc	ra,0xffffe
    80002758:	a26080e7          	jalr	-1498(ra) # 8000017a <memset>
  log_write(bp);
    8000275c:	854a                	mv	a0,s2
    8000275e:	00001097          	auipc	ra,0x1
    80002762:	080080e7          	jalr	128(ra) # 800037de <log_write>
  brelse(bp);
    80002766:	854a                	mv	a0,s2
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	dec080e7          	jalr	-532(ra) # 80002554 <brelse>
}
    80002770:	8526                	mv	a0,s1
    80002772:	60e6                	ld	ra,88(sp)
    80002774:	6446                	ld	s0,80(sp)
    80002776:	64a6                	ld	s1,72(sp)
    80002778:	6906                	ld	s2,64(sp)
    8000277a:	79e2                	ld	s3,56(sp)
    8000277c:	7a42                	ld	s4,48(sp)
    8000277e:	7aa2                	ld	s5,40(sp)
    80002780:	7b02                	ld	s6,32(sp)
    80002782:	6be2                	ld	s7,24(sp)
    80002784:	6c42                	ld	s8,16(sp)
    80002786:	6ca2                	ld	s9,8(sp)
    80002788:	6125                	addi	sp,sp,96
    8000278a:	8082                	ret
    brelse(bp);
    8000278c:	854a                	mv	a0,s2
    8000278e:	00000097          	auipc	ra,0x0
    80002792:	dc6080e7          	jalr	-570(ra) # 80002554 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002796:	015c87bb          	addw	a5,s9,s5
    8000279a:	00078a9b          	sext.w	s5,a5
    8000279e:	004b2703          	lw	a4,4(s6)
    800027a2:	06eaf163          	bgeu	s5,a4,80002804 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027a6:	41fad79b          	sraiw	a5,s5,0x1f
    800027aa:	0137d79b          	srliw	a5,a5,0x13
    800027ae:	015787bb          	addw	a5,a5,s5
    800027b2:	40d7d79b          	sraiw	a5,a5,0xd
    800027b6:	01cb2583          	lw	a1,28(s6)
    800027ba:	9dbd                	addw	a1,a1,a5
    800027bc:	855e                	mv	a0,s7
    800027be:	00000097          	auipc	ra,0x0
    800027c2:	c66080e7          	jalr	-922(ra) # 80002424 <bread>
    800027c6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c8:	004b2503          	lw	a0,4(s6)
    800027cc:	000a849b          	sext.w	s1,s5
    800027d0:	8762                	mv	a4,s8
    800027d2:	faa4fde3          	bgeu	s1,a0,8000278c <balloc+0xa6>
      m = 1 << (bi % 8);
    800027d6:	00777693          	andi	a3,a4,7
    800027da:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027de:	41f7579b          	sraiw	a5,a4,0x1f
    800027e2:	01d7d79b          	srliw	a5,a5,0x1d
    800027e6:	9fb9                	addw	a5,a5,a4
    800027e8:	4037d79b          	sraiw	a5,a5,0x3
    800027ec:	00f90633          	add	a2,s2,a5
    800027f0:	05864603          	lbu	a2,88(a2)
    800027f4:	00c6f5b3          	and	a1,a3,a2
    800027f8:	d585                	beqz	a1,80002720 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fa:	2705                	addiw	a4,a4,1
    800027fc:	2485                	addiw	s1,s1,1
    800027fe:	fd471ae3          	bne	a4,s4,800027d2 <balloc+0xec>
    80002802:	b769                	j	8000278c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002804:	00006517          	auipc	a0,0x6
    80002808:	cec50513          	addi	a0,a0,-788 # 800084f0 <syscalls+0x120>
    8000280c:	00003097          	auipc	ra,0x3
    80002810:	53a080e7          	jalr	1338(ra) # 80005d46 <printf>
  return 0;
    80002814:	4481                	li	s1,0
    80002816:	bfa9                	j	80002770 <balloc+0x8a>

0000000080002818 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002818:	7179                	addi	sp,sp,-48
    8000281a:	f406                	sd	ra,40(sp)
    8000281c:	f022                	sd	s0,32(sp)
    8000281e:	ec26                	sd	s1,24(sp)
    80002820:	e84a                	sd	s2,16(sp)
    80002822:	e44e                	sd	s3,8(sp)
    80002824:	e052                	sd	s4,0(sp)
    80002826:	1800                	addi	s0,sp,48
    80002828:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000282a:	47ad                	li	a5,11
    8000282c:	02b7e863          	bltu	a5,a1,8000285c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002830:	02059793          	slli	a5,a1,0x20
    80002834:	01e7d593          	srli	a1,a5,0x1e
    80002838:	00b504b3          	add	s1,a0,a1
    8000283c:	0504a903          	lw	s2,80(s1)
    80002840:	06091e63          	bnez	s2,800028bc <bmap+0xa4>
      addr = balloc(ip->dev);
    80002844:	4108                	lw	a0,0(a0)
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	ea0080e7          	jalr	-352(ra) # 800026e6 <balloc>
    8000284e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002852:	06090563          	beqz	s2,800028bc <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002856:	0524a823          	sw	s2,80(s1)
    8000285a:	a08d                	j	800028bc <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000285c:	ff45849b          	addiw	s1,a1,-12
    80002860:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002864:	0ff00793          	li	a5,255
    80002868:	08e7e563          	bltu	a5,a4,800028f2 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000286c:	08052903          	lw	s2,128(a0)
    80002870:	00091d63          	bnez	s2,8000288a <bmap+0x72>
      addr = balloc(ip->dev);
    80002874:	4108                	lw	a0,0(a0)
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	e70080e7          	jalr	-400(ra) # 800026e6 <balloc>
    8000287e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002882:	02090d63          	beqz	s2,800028bc <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002886:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000288a:	85ca                	mv	a1,s2
    8000288c:	0009a503          	lw	a0,0(s3)
    80002890:	00000097          	auipc	ra,0x0
    80002894:	b94080e7          	jalr	-1132(ra) # 80002424 <bread>
    80002898:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000289a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000289e:	02049713          	slli	a4,s1,0x20
    800028a2:	01e75593          	srli	a1,a4,0x1e
    800028a6:	00b784b3          	add	s1,a5,a1
    800028aa:	0004a903          	lw	s2,0(s1)
    800028ae:	02090063          	beqz	s2,800028ce <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028b2:	8552                	mv	a0,s4
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	ca0080e7          	jalr	-864(ra) # 80002554 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028bc:	854a                	mv	a0,s2
    800028be:	70a2                	ld	ra,40(sp)
    800028c0:	7402                	ld	s0,32(sp)
    800028c2:	64e2                	ld	s1,24(sp)
    800028c4:	6942                	ld	s2,16(sp)
    800028c6:	69a2                	ld	s3,8(sp)
    800028c8:	6a02                	ld	s4,0(sp)
    800028ca:	6145                	addi	sp,sp,48
    800028cc:	8082                	ret
      addr = balloc(ip->dev);
    800028ce:	0009a503          	lw	a0,0(s3)
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	e14080e7          	jalr	-492(ra) # 800026e6 <balloc>
    800028da:	0005091b          	sext.w	s2,a0
      if(addr){
    800028de:	fc090ae3          	beqz	s2,800028b2 <bmap+0x9a>
        a[bn] = addr;
    800028e2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028e6:	8552                	mv	a0,s4
    800028e8:	00001097          	auipc	ra,0x1
    800028ec:	ef6080e7          	jalr	-266(ra) # 800037de <log_write>
    800028f0:	b7c9                	j	800028b2 <bmap+0x9a>
  panic("bmap: out of range");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	c1650513          	addi	a0,a0,-1002 # 80008508 <syscalls+0x138>
    800028fa:	00003097          	auipc	ra,0x3
    800028fe:	402080e7          	jalr	1026(ra) # 80005cfc <panic>

0000000080002902 <iget>:
{
    80002902:	7179                	addi	sp,sp,-48
    80002904:	f406                	sd	ra,40(sp)
    80002906:	f022                	sd	s0,32(sp)
    80002908:	ec26                	sd	s1,24(sp)
    8000290a:	e84a                	sd	s2,16(sp)
    8000290c:	e44e                	sd	s3,8(sp)
    8000290e:	e052                	sd	s4,0(sp)
    80002910:	1800                	addi	s0,sp,48
    80002912:	89aa                	mv	s3,a0
    80002914:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002916:	00019517          	auipc	a0,0x19
    8000291a:	54250513          	addi	a0,a0,1346 # 8001be58 <itable>
    8000291e:	00004097          	auipc	ra,0x4
    80002922:	962080e7          	jalr	-1694(ra) # 80006280 <acquire>
  empty = 0;
    80002926:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002928:	00019497          	auipc	s1,0x19
    8000292c:	54848493          	addi	s1,s1,1352 # 8001be70 <itable+0x18>
    80002930:	0001b697          	auipc	a3,0x1b
    80002934:	fd068693          	addi	a3,a3,-48 # 8001d900 <log>
    80002938:	a039                	j	80002946 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000293a:	02090b63          	beqz	s2,80002970 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000293e:	08848493          	addi	s1,s1,136
    80002942:	02d48a63          	beq	s1,a3,80002976 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002946:	449c                	lw	a5,8(s1)
    80002948:	fef059e3          	blez	a5,8000293a <iget+0x38>
    8000294c:	4098                	lw	a4,0(s1)
    8000294e:	ff3716e3          	bne	a4,s3,8000293a <iget+0x38>
    80002952:	40d8                	lw	a4,4(s1)
    80002954:	ff4713e3          	bne	a4,s4,8000293a <iget+0x38>
      ip->ref++;
    80002958:	2785                	addiw	a5,a5,1
    8000295a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000295c:	00019517          	auipc	a0,0x19
    80002960:	4fc50513          	addi	a0,a0,1276 # 8001be58 <itable>
    80002964:	00004097          	auipc	ra,0x4
    80002968:	9d0080e7          	jalr	-1584(ra) # 80006334 <release>
      return ip;
    8000296c:	8926                	mv	s2,s1
    8000296e:	a03d                	j	8000299c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002970:	f7f9                	bnez	a5,8000293e <iget+0x3c>
    80002972:	8926                	mv	s2,s1
    80002974:	b7e9                	j	8000293e <iget+0x3c>
  if(empty == 0)
    80002976:	02090c63          	beqz	s2,800029ae <iget+0xac>
  ip->dev = dev;
    8000297a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000297e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002982:	4785                	li	a5,1
    80002984:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002988:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000298c:	00019517          	auipc	a0,0x19
    80002990:	4cc50513          	addi	a0,a0,1228 # 8001be58 <itable>
    80002994:	00004097          	auipc	ra,0x4
    80002998:	9a0080e7          	jalr	-1632(ra) # 80006334 <release>
}
    8000299c:	854a                	mv	a0,s2
    8000299e:	70a2                	ld	ra,40(sp)
    800029a0:	7402                	ld	s0,32(sp)
    800029a2:	64e2                	ld	s1,24(sp)
    800029a4:	6942                	ld	s2,16(sp)
    800029a6:	69a2                	ld	s3,8(sp)
    800029a8:	6a02                	ld	s4,0(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret
    panic("iget: no inodes");
    800029ae:	00006517          	auipc	a0,0x6
    800029b2:	b7250513          	addi	a0,a0,-1166 # 80008520 <syscalls+0x150>
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	346080e7          	jalr	838(ra) # 80005cfc <panic>

00000000800029be <fsinit>:
fsinit(int dev) {
    800029be:	7179                	addi	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	e84a                	sd	s2,16(sp)
    800029c8:	e44e                	sd	s3,8(sp)
    800029ca:	1800                	addi	s0,sp,48
    800029cc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029ce:	4585                	li	a1,1
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	a54080e7          	jalr	-1452(ra) # 80002424 <bread>
    800029d8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029da:	00019997          	auipc	s3,0x19
    800029de:	45e98993          	addi	s3,s3,1118 # 8001be38 <sb>
    800029e2:	02000613          	li	a2,32
    800029e6:	05850593          	addi	a1,a0,88
    800029ea:	854e                	mv	a0,s3
    800029ec:	ffffd097          	auipc	ra,0xffffd
    800029f0:	7ea080e7          	jalr	2026(ra) # 800001d6 <memmove>
  brelse(bp);
    800029f4:	8526                	mv	a0,s1
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	b5e080e7          	jalr	-1186(ra) # 80002554 <brelse>
  if(sb.magic != FSMAGIC)
    800029fe:	0009a703          	lw	a4,0(s3)
    80002a02:	102037b7          	lui	a5,0x10203
    80002a06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a0a:	02f71263          	bne	a4,a5,80002a2e <fsinit+0x70>
  initlog(dev, &sb);
    80002a0e:	00019597          	auipc	a1,0x19
    80002a12:	42a58593          	addi	a1,a1,1066 # 8001be38 <sb>
    80002a16:	854a                	mv	a0,s2
    80002a18:	00001097          	auipc	ra,0x1
    80002a1c:	b4a080e7          	jalr	-1206(ra) # 80003562 <initlog>
}
    80002a20:	70a2                	ld	ra,40(sp)
    80002a22:	7402                	ld	s0,32(sp)
    80002a24:	64e2                	ld	s1,24(sp)
    80002a26:	6942                	ld	s2,16(sp)
    80002a28:	69a2                	ld	s3,8(sp)
    80002a2a:	6145                	addi	sp,sp,48
    80002a2c:	8082                	ret
    panic("invalid file system");
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	b0250513          	addi	a0,a0,-1278 # 80008530 <syscalls+0x160>
    80002a36:	00003097          	auipc	ra,0x3
    80002a3a:	2c6080e7          	jalr	710(ra) # 80005cfc <panic>

0000000080002a3e <iinit>:
{
    80002a3e:	7179                	addi	sp,sp,-48
    80002a40:	f406                	sd	ra,40(sp)
    80002a42:	f022                	sd	s0,32(sp)
    80002a44:	ec26                	sd	s1,24(sp)
    80002a46:	e84a                	sd	s2,16(sp)
    80002a48:	e44e                	sd	s3,8(sp)
    80002a4a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a4c:	00006597          	auipc	a1,0x6
    80002a50:	afc58593          	addi	a1,a1,-1284 # 80008548 <syscalls+0x178>
    80002a54:	00019517          	auipc	a0,0x19
    80002a58:	40450513          	addi	a0,a0,1028 # 8001be58 <itable>
    80002a5c:	00003097          	auipc	ra,0x3
    80002a60:	794080e7          	jalr	1940(ra) # 800061f0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a64:	00019497          	auipc	s1,0x19
    80002a68:	41c48493          	addi	s1,s1,1052 # 8001be80 <itable+0x28>
    80002a6c:	0001b997          	auipc	s3,0x1b
    80002a70:	ea498993          	addi	s3,s3,-348 # 8001d910 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a74:	00006917          	auipc	s2,0x6
    80002a78:	adc90913          	addi	s2,s2,-1316 # 80008550 <syscalls+0x180>
    80002a7c:	85ca                	mv	a1,s2
    80002a7e:	8526                	mv	a0,s1
    80002a80:	00001097          	auipc	ra,0x1
    80002a84:	e42080e7          	jalr	-446(ra) # 800038c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a88:	08848493          	addi	s1,s1,136
    80002a8c:	ff3498e3          	bne	s1,s3,80002a7c <iinit+0x3e>
}
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6145                	addi	sp,sp,48
    80002a9c:	8082                	ret

0000000080002a9e <ialloc>:
{
    80002a9e:	715d                	addi	sp,sp,-80
    80002aa0:	e486                	sd	ra,72(sp)
    80002aa2:	e0a2                	sd	s0,64(sp)
    80002aa4:	fc26                	sd	s1,56(sp)
    80002aa6:	f84a                	sd	s2,48(sp)
    80002aa8:	f44e                	sd	s3,40(sp)
    80002aaa:	f052                	sd	s4,32(sp)
    80002aac:	ec56                	sd	s5,24(sp)
    80002aae:	e85a                	sd	s6,16(sp)
    80002ab0:	e45e                	sd	s7,8(sp)
    80002ab2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab4:	00019717          	auipc	a4,0x19
    80002ab8:	39072703          	lw	a4,912(a4) # 8001be44 <sb+0xc>
    80002abc:	4785                	li	a5,1
    80002abe:	04e7fa63          	bgeu	a5,a4,80002b12 <ialloc+0x74>
    80002ac2:	8aaa                	mv	s5,a0
    80002ac4:	8bae                	mv	s7,a1
    80002ac6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ac8:	00019a17          	auipc	s4,0x19
    80002acc:	370a0a13          	addi	s4,s4,880 # 8001be38 <sb>
    80002ad0:	00048b1b          	sext.w	s6,s1
    80002ad4:	0044d593          	srli	a1,s1,0x4
    80002ad8:	018a2783          	lw	a5,24(s4)
    80002adc:	9dbd                	addw	a1,a1,a5
    80002ade:	8556                	mv	a0,s5
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	944080e7          	jalr	-1724(ra) # 80002424 <bread>
    80002ae8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aea:	05850993          	addi	s3,a0,88
    80002aee:	00f4f793          	andi	a5,s1,15
    80002af2:	079a                	slli	a5,a5,0x6
    80002af4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002af6:	00099783          	lh	a5,0(s3)
    80002afa:	c3a1                	beqz	a5,80002b3a <ialloc+0x9c>
    brelse(bp);
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	a58080e7          	jalr	-1448(ra) # 80002554 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b04:	0485                	addi	s1,s1,1
    80002b06:	00ca2703          	lw	a4,12(s4)
    80002b0a:	0004879b          	sext.w	a5,s1
    80002b0e:	fce7e1e3          	bltu	a5,a4,80002ad0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b12:	00006517          	auipc	a0,0x6
    80002b16:	a4650513          	addi	a0,a0,-1466 # 80008558 <syscalls+0x188>
    80002b1a:	00003097          	auipc	ra,0x3
    80002b1e:	22c080e7          	jalr	556(ra) # 80005d46 <printf>
  return 0;
    80002b22:	4501                	li	a0,0
}
    80002b24:	60a6                	ld	ra,72(sp)
    80002b26:	6406                	ld	s0,64(sp)
    80002b28:	74e2                	ld	s1,56(sp)
    80002b2a:	7942                	ld	s2,48(sp)
    80002b2c:	79a2                	ld	s3,40(sp)
    80002b2e:	7a02                	ld	s4,32(sp)
    80002b30:	6ae2                	ld	s5,24(sp)
    80002b32:	6b42                	ld	s6,16(sp)
    80002b34:	6ba2                	ld	s7,8(sp)
    80002b36:	6161                	addi	sp,sp,80
    80002b38:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b3a:	04000613          	li	a2,64
    80002b3e:	4581                	li	a1,0
    80002b40:	854e                	mv	a0,s3
    80002b42:	ffffd097          	auipc	ra,0xffffd
    80002b46:	638080e7          	jalr	1592(ra) # 8000017a <memset>
      dip->type = type;
    80002b4a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b4e:	854a                	mv	a0,s2
    80002b50:	00001097          	auipc	ra,0x1
    80002b54:	c8e080e7          	jalr	-882(ra) # 800037de <log_write>
      brelse(bp);
    80002b58:	854a                	mv	a0,s2
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	9fa080e7          	jalr	-1542(ra) # 80002554 <brelse>
      return iget(dev, inum);
    80002b62:	85da                	mv	a1,s6
    80002b64:	8556                	mv	a0,s5
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	d9c080e7          	jalr	-612(ra) # 80002902 <iget>
    80002b6e:	bf5d                	j	80002b24 <ialloc+0x86>

0000000080002b70 <iupdate>:
{
    80002b70:	1101                	addi	sp,sp,-32
    80002b72:	ec06                	sd	ra,24(sp)
    80002b74:	e822                	sd	s0,16(sp)
    80002b76:	e426                	sd	s1,8(sp)
    80002b78:	e04a                	sd	s2,0(sp)
    80002b7a:	1000                	addi	s0,sp,32
    80002b7c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b7e:	415c                	lw	a5,4(a0)
    80002b80:	0047d79b          	srliw	a5,a5,0x4
    80002b84:	00019597          	auipc	a1,0x19
    80002b88:	2cc5a583          	lw	a1,716(a1) # 8001be50 <sb+0x18>
    80002b8c:	9dbd                	addw	a1,a1,a5
    80002b8e:	4108                	lw	a0,0(a0)
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	894080e7          	jalr	-1900(ra) # 80002424 <bread>
    80002b98:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b9a:	05850793          	addi	a5,a0,88
    80002b9e:	40d8                	lw	a4,4(s1)
    80002ba0:	8b3d                	andi	a4,a4,15
    80002ba2:	071a                	slli	a4,a4,0x6
    80002ba4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ba6:	04449703          	lh	a4,68(s1)
    80002baa:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bae:	04649703          	lh	a4,70(s1)
    80002bb2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bb6:	04849703          	lh	a4,72(s1)
    80002bba:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bbe:	04a49703          	lh	a4,74(s1)
    80002bc2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bc6:	44f8                	lw	a4,76(s1)
    80002bc8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bca:	03400613          	li	a2,52
    80002bce:	05048593          	addi	a1,s1,80
    80002bd2:	00c78513          	addi	a0,a5,12
    80002bd6:	ffffd097          	auipc	ra,0xffffd
    80002bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bde:	854a                	mv	a0,s2
    80002be0:	00001097          	auipc	ra,0x1
    80002be4:	bfe080e7          	jalr	-1026(ra) # 800037de <log_write>
  brelse(bp);
    80002be8:	854a                	mv	a0,s2
    80002bea:	00000097          	auipc	ra,0x0
    80002bee:	96a080e7          	jalr	-1686(ra) # 80002554 <brelse>
}
    80002bf2:	60e2                	ld	ra,24(sp)
    80002bf4:	6442                	ld	s0,16(sp)
    80002bf6:	64a2                	ld	s1,8(sp)
    80002bf8:	6902                	ld	s2,0(sp)
    80002bfa:	6105                	addi	sp,sp,32
    80002bfc:	8082                	ret

0000000080002bfe <idup>:
{
    80002bfe:	1101                	addi	sp,sp,-32
    80002c00:	ec06                	sd	ra,24(sp)
    80002c02:	e822                	sd	s0,16(sp)
    80002c04:	e426                	sd	s1,8(sp)
    80002c06:	1000                	addi	s0,sp,32
    80002c08:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c0a:	00019517          	auipc	a0,0x19
    80002c0e:	24e50513          	addi	a0,a0,590 # 8001be58 <itable>
    80002c12:	00003097          	auipc	ra,0x3
    80002c16:	66e080e7          	jalr	1646(ra) # 80006280 <acquire>
  ip->ref++;
    80002c1a:	449c                	lw	a5,8(s1)
    80002c1c:	2785                	addiw	a5,a5,1
    80002c1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c20:	00019517          	auipc	a0,0x19
    80002c24:	23850513          	addi	a0,a0,568 # 8001be58 <itable>
    80002c28:	00003097          	auipc	ra,0x3
    80002c2c:	70c080e7          	jalr	1804(ra) # 80006334 <release>
}
    80002c30:	8526                	mv	a0,s1
    80002c32:	60e2                	ld	ra,24(sp)
    80002c34:	6442                	ld	s0,16(sp)
    80002c36:	64a2                	ld	s1,8(sp)
    80002c38:	6105                	addi	sp,sp,32
    80002c3a:	8082                	ret

0000000080002c3c <ilock>:
{
    80002c3c:	1101                	addi	sp,sp,-32
    80002c3e:	ec06                	sd	ra,24(sp)
    80002c40:	e822                	sd	s0,16(sp)
    80002c42:	e426                	sd	s1,8(sp)
    80002c44:	e04a                	sd	s2,0(sp)
    80002c46:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c48:	c115                	beqz	a0,80002c6c <ilock+0x30>
    80002c4a:	84aa                	mv	s1,a0
    80002c4c:	451c                	lw	a5,8(a0)
    80002c4e:	00f05f63          	blez	a5,80002c6c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c52:	0541                	addi	a0,a0,16
    80002c54:	00001097          	auipc	ra,0x1
    80002c58:	ca8080e7          	jalr	-856(ra) # 800038fc <acquiresleep>
  if(ip->valid == 0){
    80002c5c:	40bc                	lw	a5,64(s1)
    80002c5e:	cf99                	beqz	a5,80002c7c <ilock+0x40>
}
    80002c60:	60e2                	ld	ra,24(sp)
    80002c62:	6442                	ld	s0,16(sp)
    80002c64:	64a2                	ld	s1,8(sp)
    80002c66:	6902                	ld	s2,0(sp)
    80002c68:	6105                	addi	sp,sp,32
    80002c6a:	8082                	ret
    panic("ilock");
    80002c6c:	00006517          	auipc	a0,0x6
    80002c70:	90450513          	addi	a0,a0,-1788 # 80008570 <syscalls+0x1a0>
    80002c74:	00003097          	auipc	ra,0x3
    80002c78:	088080e7          	jalr	136(ra) # 80005cfc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c7c:	40dc                	lw	a5,4(s1)
    80002c7e:	0047d79b          	srliw	a5,a5,0x4
    80002c82:	00019597          	auipc	a1,0x19
    80002c86:	1ce5a583          	lw	a1,462(a1) # 8001be50 <sb+0x18>
    80002c8a:	9dbd                	addw	a1,a1,a5
    80002c8c:	4088                	lw	a0,0(s1)
    80002c8e:	fffff097          	auipc	ra,0xfffff
    80002c92:	796080e7          	jalr	1942(ra) # 80002424 <bread>
    80002c96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c98:	05850593          	addi	a1,a0,88
    80002c9c:	40dc                	lw	a5,4(s1)
    80002c9e:	8bbd                	andi	a5,a5,15
    80002ca0:	079a                	slli	a5,a5,0x6
    80002ca2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ca4:	00059783          	lh	a5,0(a1)
    80002ca8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cac:	00259783          	lh	a5,2(a1)
    80002cb0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cb4:	00459783          	lh	a5,4(a1)
    80002cb8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cbc:	00659783          	lh	a5,6(a1)
    80002cc0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cc4:	459c                	lw	a5,8(a1)
    80002cc6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cc8:	03400613          	li	a2,52
    80002ccc:	05b1                	addi	a1,a1,12
    80002cce:	05048513          	addi	a0,s1,80
    80002cd2:	ffffd097          	auipc	ra,0xffffd
    80002cd6:	504080e7          	jalr	1284(ra) # 800001d6 <memmove>
    brelse(bp);
    80002cda:	854a                	mv	a0,s2
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	878080e7          	jalr	-1928(ra) # 80002554 <brelse>
    ip->valid = 1;
    80002ce4:	4785                	li	a5,1
    80002ce6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ce8:	04449783          	lh	a5,68(s1)
    80002cec:	fbb5                	bnez	a5,80002c60 <ilock+0x24>
      panic("ilock: no type");
    80002cee:	00006517          	auipc	a0,0x6
    80002cf2:	88a50513          	addi	a0,a0,-1910 # 80008578 <syscalls+0x1a8>
    80002cf6:	00003097          	auipc	ra,0x3
    80002cfa:	006080e7          	jalr	6(ra) # 80005cfc <panic>

0000000080002cfe <iunlock>:
{
    80002cfe:	1101                	addi	sp,sp,-32
    80002d00:	ec06                	sd	ra,24(sp)
    80002d02:	e822                	sd	s0,16(sp)
    80002d04:	e426                	sd	s1,8(sp)
    80002d06:	e04a                	sd	s2,0(sp)
    80002d08:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d0a:	c905                	beqz	a0,80002d3a <iunlock+0x3c>
    80002d0c:	84aa                	mv	s1,a0
    80002d0e:	01050913          	addi	s2,a0,16
    80002d12:	854a                	mv	a0,s2
    80002d14:	00001097          	auipc	ra,0x1
    80002d18:	c82080e7          	jalr	-894(ra) # 80003996 <holdingsleep>
    80002d1c:	cd19                	beqz	a0,80002d3a <iunlock+0x3c>
    80002d1e:	449c                	lw	a5,8(s1)
    80002d20:	00f05d63          	blez	a5,80002d3a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d24:	854a                	mv	a0,s2
    80002d26:	00001097          	auipc	ra,0x1
    80002d2a:	c2c080e7          	jalr	-980(ra) # 80003952 <releasesleep>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6902                	ld	s2,0(sp)
    80002d36:	6105                	addi	sp,sp,32
    80002d38:	8082                	ret
    panic("iunlock");
    80002d3a:	00006517          	auipc	a0,0x6
    80002d3e:	84e50513          	addi	a0,a0,-1970 # 80008588 <syscalls+0x1b8>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	fba080e7          	jalr	-70(ra) # 80005cfc <panic>

0000000080002d4a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d4a:	7179                	addi	sp,sp,-48
    80002d4c:	f406                	sd	ra,40(sp)
    80002d4e:	f022                	sd	s0,32(sp)
    80002d50:	ec26                	sd	s1,24(sp)
    80002d52:	e84a                	sd	s2,16(sp)
    80002d54:	e44e                	sd	s3,8(sp)
    80002d56:	e052                	sd	s4,0(sp)
    80002d58:	1800                	addi	s0,sp,48
    80002d5a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d5c:	05050493          	addi	s1,a0,80
    80002d60:	08050913          	addi	s2,a0,128
    80002d64:	a021                	j	80002d6c <itrunc+0x22>
    80002d66:	0491                	addi	s1,s1,4
    80002d68:	01248d63          	beq	s1,s2,80002d82 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d6c:	408c                	lw	a1,0(s1)
    80002d6e:	dde5                	beqz	a1,80002d66 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d70:	0009a503          	lw	a0,0(s3)
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	8f6080e7          	jalr	-1802(ra) # 8000266a <bfree>
      ip->addrs[i] = 0;
    80002d7c:	0004a023          	sw	zero,0(s1)
    80002d80:	b7dd                	j	80002d66 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d82:	0809a583          	lw	a1,128(s3)
    80002d86:	e185                	bnez	a1,80002da6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d88:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d8c:	854e                	mv	a0,s3
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	de2080e7          	jalr	-542(ra) # 80002b70 <iupdate>
}
    80002d96:	70a2                	ld	ra,40(sp)
    80002d98:	7402                	ld	s0,32(sp)
    80002d9a:	64e2                	ld	s1,24(sp)
    80002d9c:	6942                	ld	s2,16(sp)
    80002d9e:	69a2                	ld	s3,8(sp)
    80002da0:	6a02                	ld	s4,0(sp)
    80002da2:	6145                	addi	sp,sp,48
    80002da4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002da6:	0009a503          	lw	a0,0(s3)
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	67a080e7          	jalr	1658(ra) # 80002424 <bread>
    80002db2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002db4:	05850493          	addi	s1,a0,88
    80002db8:	45850913          	addi	s2,a0,1112
    80002dbc:	a021                	j	80002dc4 <itrunc+0x7a>
    80002dbe:	0491                	addi	s1,s1,4
    80002dc0:	01248b63          	beq	s1,s2,80002dd6 <itrunc+0x8c>
      if(a[j])
    80002dc4:	408c                	lw	a1,0(s1)
    80002dc6:	dde5                	beqz	a1,80002dbe <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002dc8:	0009a503          	lw	a0,0(s3)
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	89e080e7          	jalr	-1890(ra) # 8000266a <bfree>
    80002dd4:	b7ed                	j	80002dbe <itrunc+0x74>
    brelse(bp);
    80002dd6:	8552                	mv	a0,s4
    80002dd8:	fffff097          	auipc	ra,0xfffff
    80002ddc:	77c080e7          	jalr	1916(ra) # 80002554 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002de0:	0809a583          	lw	a1,128(s3)
    80002de4:	0009a503          	lw	a0,0(s3)
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	882080e7          	jalr	-1918(ra) # 8000266a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002df0:	0809a023          	sw	zero,128(s3)
    80002df4:	bf51                	j	80002d88 <itrunc+0x3e>

0000000080002df6 <iput>:
{
    80002df6:	1101                	addi	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	e426                	sd	s1,8(sp)
    80002dfe:	e04a                	sd	s2,0(sp)
    80002e00:	1000                	addi	s0,sp,32
    80002e02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e04:	00019517          	auipc	a0,0x19
    80002e08:	05450513          	addi	a0,a0,84 # 8001be58 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	474080e7          	jalr	1140(ra) # 80006280 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e14:	4498                	lw	a4,8(s1)
    80002e16:	4785                	li	a5,1
    80002e18:	02f70363          	beq	a4,a5,80002e3e <iput+0x48>
  ip->ref--;
    80002e1c:	449c                	lw	a5,8(s1)
    80002e1e:	37fd                	addiw	a5,a5,-1
    80002e20:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e22:	00019517          	auipc	a0,0x19
    80002e26:	03650513          	addi	a0,a0,54 # 8001be58 <itable>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	50a080e7          	jalr	1290(ra) # 80006334 <release>
}
    80002e32:	60e2                	ld	ra,24(sp)
    80002e34:	6442                	ld	s0,16(sp)
    80002e36:	64a2                	ld	s1,8(sp)
    80002e38:	6902                	ld	s2,0(sp)
    80002e3a:	6105                	addi	sp,sp,32
    80002e3c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e3e:	40bc                	lw	a5,64(s1)
    80002e40:	dff1                	beqz	a5,80002e1c <iput+0x26>
    80002e42:	04a49783          	lh	a5,74(s1)
    80002e46:	fbf9                	bnez	a5,80002e1c <iput+0x26>
    acquiresleep(&ip->lock);
    80002e48:	01048913          	addi	s2,s1,16
    80002e4c:	854a                	mv	a0,s2
    80002e4e:	00001097          	auipc	ra,0x1
    80002e52:	aae080e7          	jalr	-1362(ra) # 800038fc <acquiresleep>
    release(&itable.lock);
    80002e56:	00019517          	auipc	a0,0x19
    80002e5a:	00250513          	addi	a0,a0,2 # 8001be58 <itable>
    80002e5e:	00003097          	auipc	ra,0x3
    80002e62:	4d6080e7          	jalr	1238(ra) # 80006334 <release>
    itrunc(ip);
    80002e66:	8526                	mv	a0,s1
    80002e68:	00000097          	auipc	ra,0x0
    80002e6c:	ee2080e7          	jalr	-286(ra) # 80002d4a <itrunc>
    ip->type = 0;
    80002e70:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e74:	8526                	mv	a0,s1
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	cfa080e7          	jalr	-774(ra) # 80002b70 <iupdate>
    ip->valid = 0;
    80002e7e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e82:	854a                	mv	a0,s2
    80002e84:	00001097          	auipc	ra,0x1
    80002e88:	ace080e7          	jalr	-1330(ra) # 80003952 <releasesleep>
    acquire(&itable.lock);
    80002e8c:	00019517          	auipc	a0,0x19
    80002e90:	fcc50513          	addi	a0,a0,-52 # 8001be58 <itable>
    80002e94:	00003097          	auipc	ra,0x3
    80002e98:	3ec080e7          	jalr	1004(ra) # 80006280 <acquire>
    80002e9c:	b741                	j	80002e1c <iput+0x26>

0000000080002e9e <iunlockput>:
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	e426                	sd	s1,8(sp)
    80002ea6:	1000                	addi	s0,sp,32
    80002ea8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	e54080e7          	jalr	-428(ra) # 80002cfe <iunlock>
  iput(ip);
    80002eb2:	8526                	mv	a0,s1
    80002eb4:	00000097          	auipc	ra,0x0
    80002eb8:	f42080e7          	jalr	-190(ra) # 80002df6 <iput>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6105                	addi	sp,sp,32
    80002ec4:	8082                	ret

0000000080002ec6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ec6:	1141                	addi	sp,sp,-16
    80002ec8:	e422                	sd	s0,8(sp)
    80002eca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ecc:	411c                	lw	a5,0(a0)
    80002ece:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ed0:	415c                	lw	a5,4(a0)
    80002ed2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ed4:	04451783          	lh	a5,68(a0)
    80002ed8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002edc:	04a51783          	lh	a5,74(a0)
    80002ee0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ee4:	04c56783          	lwu	a5,76(a0)
    80002ee8:	e99c                	sd	a5,16(a1)
}
    80002eea:	6422                	ld	s0,8(sp)
    80002eec:	0141                	addi	sp,sp,16
    80002eee:	8082                	ret

0000000080002ef0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ef0:	457c                	lw	a5,76(a0)
    80002ef2:	0ed7e963          	bltu	a5,a3,80002fe4 <readi+0xf4>
{
    80002ef6:	7159                	addi	sp,sp,-112
    80002ef8:	f486                	sd	ra,104(sp)
    80002efa:	f0a2                	sd	s0,96(sp)
    80002efc:	eca6                	sd	s1,88(sp)
    80002efe:	e8ca                	sd	s2,80(sp)
    80002f00:	e4ce                	sd	s3,72(sp)
    80002f02:	e0d2                	sd	s4,64(sp)
    80002f04:	fc56                	sd	s5,56(sp)
    80002f06:	f85a                	sd	s6,48(sp)
    80002f08:	f45e                	sd	s7,40(sp)
    80002f0a:	f062                	sd	s8,32(sp)
    80002f0c:	ec66                	sd	s9,24(sp)
    80002f0e:	e86a                	sd	s10,16(sp)
    80002f10:	e46e                	sd	s11,8(sp)
    80002f12:	1880                	addi	s0,sp,112
    80002f14:	8b2a                	mv	s6,a0
    80002f16:	8bae                	mv	s7,a1
    80002f18:	8a32                	mv	s4,a2
    80002f1a:	84b6                	mv	s1,a3
    80002f1c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f1e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f22:	0ad76063          	bltu	a4,a3,80002fc2 <readi+0xd2>
  if(off + n > ip->size)
    80002f26:	00e7f463          	bgeu	a5,a4,80002f2e <readi+0x3e>
    n = ip->size - off;
    80002f2a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f2e:	0a0a8963          	beqz	s5,80002fe0 <readi+0xf0>
    80002f32:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f34:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f38:	5c7d                	li	s8,-1
    80002f3a:	a82d                	j	80002f74 <readi+0x84>
    80002f3c:	020d1d93          	slli	s11,s10,0x20
    80002f40:	020ddd93          	srli	s11,s11,0x20
    80002f44:	05890613          	addi	a2,s2,88
    80002f48:	86ee                	mv	a3,s11
    80002f4a:	963a                	add	a2,a2,a4
    80002f4c:	85d2                	mv	a1,s4
    80002f4e:	855e                	mv	a0,s7
    80002f50:	fffff097          	auipc	ra,0xfffff
    80002f54:	9ec080e7          	jalr	-1556(ra) # 8000193c <either_copyout>
    80002f58:	05850d63          	beq	a0,s8,80002fb2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f5c:	854a                	mv	a0,s2
    80002f5e:	fffff097          	auipc	ra,0xfffff
    80002f62:	5f6080e7          	jalr	1526(ra) # 80002554 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f66:	013d09bb          	addw	s3,s10,s3
    80002f6a:	009d04bb          	addw	s1,s10,s1
    80002f6e:	9a6e                	add	s4,s4,s11
    80002f70:	0559f763          	bgeu	s3,s5,80002fbe <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f74:	00a4d59b          	srliw	a1,s1,0xa
    80002f78:	855a                	mv	a0,s6
    80002f7a:	00000097          	auipc	ra,0x0
    80002f7e:	89e080e7          	jalr	-1890(ra) # 80002818 <bmap>
    80002f82:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f86:	cd85                	beqz	a1,80002fbe <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f88:	000b2503          	lw	a0,0(s6)
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	498080e7          	jalr	1176(ra) # 80002424 <bread>
    80002f94:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f96:	3ff4f713          	andi	a4,s1,1023
    80002f9a:	40ec87bb          	subw	a5,s9,a4
    80002f9e:	413a86bb          	subw	a3,s5,s3
    80002fa2:	8d3e                	mv	s10,a5
    80002fa4:	2781                	sext.w	a5,a5
    80002fa6:	0006861b          	sext.w	a2,a3
    80002faa:	f8f679e3          	bgeu	a2,a5,80002f3c <readi+0x4c>
    80002fae:	8d36                	mv	s10,a3
    80002fb0:	b771                	j	80002f3c <readi+0x4c>
      brelse(bp);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	5a0080e7          	jalr	1440(ra) # 80002554 <brelse>
      tot = -1;
    80002fbc:	59fd                	li	s3,-1
  }
  return tot;
    80002fbe:	0009851b          	sext.w	a0,s3
}
    80002fc2:	70a6                	ld	ra,104(sp)
    80002fc4:	7406                	ld	s0,96(sp)
    80002fc6:	64e6                	ld	s1,88(sp)
    80002fc8:	6946                	ld	s2,80(sp)
    80002fca:	69a6                	ld	s3,72(sp)
    80002fcc:	6a06                	ld	s4,64(sp)
    80002fce:	7ae2                	ld	s5,56(sp)
    80002fd0:	7b42                	ld	s6,48(sp)
    80002fd2:	7ba2                	ld	s7,40(sp)
    80002fd4:	7c02                	ld	s8,32(sp)
    80002fd6:	6ce2                	ld	s9,24(sp)
    80002fd8:	6d42                	ld	s10,16(sp)
    80002fda:	6da2                	ld	s11,8(sp)
    80002fdc:	6165                	addi	sp,sp,112
    80002fde:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe0:	89d6                	mv	s3,s5
    80002fe2:	bff1                	j	80002fbe <readi+0xce>
    return 0;
    80002fe4:	4501                	li	a0,0
}
    80002fe6:	8082                	ret

0000000080002fe8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe8:	457c                	lw	a5,76(a0)
    80002fea:	10d7e863          	bltu	a5,a3,800030fa <writei+0x112>
{
    80002fee:	7159                	addi	sp,sp,-112
    80002ff0:	f486                	sd	ra,104(sp)
    80002ff2:	f0a2                	sd	s0,96(sp)
    80002ff4:	eca6                	sd	s1,88(sp)
    80002ff6:	e8ca                	sd	s2,80(sp)
    80002ff8:	e4ce                	sd	s3,72(sp)
    80002ffa:	e0d2                	sd	s4,64(sp)
    80002ffc:	fc56                	sd	s5,56(sp)
    80002ffe:	f85a                	sd	s6,48(sp)
    80003000:	f45e                	sd	s7,40(sp)
    80003002:	f062                	sd	s8,32(sp)
    80003004:	ec66                	sd	s9,24(sp)
    80003006:	e86a                	sd	s10,16(sp)
    80003008:	e46e                	sd	s11,8(sp)
    8000300a:	1880                	addi	s0,sp,112
    8000300c:	8aaa                	mv	s5,a0
    8000300e:	8bae                	mv	s7,a1
    80003010:	8a32                	mv	s4,a2
    80003012:	8936                	mv	s2,a3
    80003014:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003016:	00e687bb          	addw	a5,a3,a4
    8000301a:	0ed7e263          	bltu	a5,a3,800030fe <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000301e:	00043737          	lui	a4,0x43
    80003022:	0ef76063          	bltu	a4,a5,80003102 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003026:	0c0b0863          	beqz	s6,800030f6 <writei+0x10e>
    8000302a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003030:	5c7d                	li	s8,-1
    80003032:	a091                	j	80003076 <writei+0x8e>
    80003034:	020d1d93          	slli	s11,s10,0x20
    80003038:	020ddd93          	srli	s11,s11,0x20
    8000303c:	05848513          	addi	a0,s1,88
    80003040:	86ee                	mv	a3,s11
    80003042:	8652                	mv	a2,s4
    80003044:	85de                	mv	a1,s7
    80003046:	953a                	add	a0,a0,a4
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	94c080e7          	jalr	-1716(ra) # 80001994 <either_copyin>
    80003050:	07850263          	beq	a0,s8,800030b4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003054:	8526                	mv	a0,s1
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	788080e7          	jalr	1928(ra) # 800037de <log_write>
    brelse(bp);
    8000305e:	8526                	mv	a0,s1
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	4f4080e7          	jalr	1268(ra) # 80002554 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003068:	013d09bb          	addw	s3,s10,s3
    8000306c:	012d093b          	addw	s2,s10,s2
    80003070:	9a6e                	add	s4,s4,s11
    80003072:	0569f663          	bgeu	s3,s6,800030be <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003076:	00a9559b          	srliw	a1,s2,0xa
    8000307a:	8556                	mv	a0,s5
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	79c080e7          	jalr	1948(ra) # 80002818 <bmap>
    80003084:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003088:	c99d                	beqz	a1,800030be <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000308a:	000aa503          	lw	a0,0(s5)
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	396080e7          	jalr	918(ra) # 80002424 <bread>
    80003096:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003098:	3ff97713          	andi	a4,s2,1023
    8000309c:	40ec87bb          	subw	a5,s9,a4
    800030a0:	413b06bb          	subw	a3,s6,s3
    800030a4:	8d3e                	mv	s10,a5
    800030a6:	2781                	sext.w	a5,a5
    800030a8:	0006861b          	sext.w	a2,a3
    800030ac:	f8f674e3          	bgeu	a2,a5,80003034 <writei+0x4c>
    800030b0:	8d36                	mv	s10,a3
    800030b2:	b749                	j	80003034 <writei+0x4c>
      brelse(bp);
    800030b4:	8526                	mv	a0,s1
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	49e080e7          	jalr	1182(ra) # 80002554 <brelse>
  }

  if(off > ip->size)
    800030be:	04caa783          	lw	a5,76(s5)
    800030c2:	0127f463          	bgeu	a5,s2,800030ca <writei+0xe2>
    ip->size = off;
    800030c6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030ca:	8556                	mv	a0,s5
    800030cc:	00000097          	auipc	ra,0x0
    800030d0:	aa4080e7          	jalr	-1372(ra) # 80002b70 <iupdate>

  return tot;
    800030d4:	0009851b          	sext.w	a0,s3
}
    800030d8:	70a6                	ld	ra,104(sp)
    800030da:	7406                	ld	s0,96(sp)
    800030dc:	64e6                	ld	s1,88(sp)
    800030de:	6946                	ld	s2,80(sp)
    800030e0:	69a6                	ld	s3,72(sp)
    800030e2:	6a06                	ld	s4,64(sp)
    800030e4:	7ae2                	ld	s5,56(sp)
    800030e6:	7b42                	ld	s6,48(sp)
    800030e8:	7ba2                	ld	s7,40(sp)
    800030ea:	7c02                	ld	s8,32(sp)
    800030ec:	6ce2                	ld	s9,24(sp)
    800030ee:	6d42                	ld	s10,16(sp)
    800030f0:	6da2                	ld	s11,8(sp)
    800030f2:	6165                	addi	sp,sp,112
    800030f4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f6:	89da                	mv	s3,s6
    800030f8:	bfc9                	j	800030ca <writei+0xe2>
    return -1;
    800030fa:	557d                	li	a0,-1
}
    800030fc:	8082                	ret
    return -1;
    800030fe:	557d                	li	a0,-1
    80003100:	bfe1                	j	800030d8 <writei+0xf0>
    return -1;
    80003102:	557d                	li	a0,-1
    80003104:	bfd1                	j	800030d8 <writei+0xf0>

0000000080003106 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003106:	1141                	addi	sp,sp,-16
    80003108:	e406                	sd	ra,8(sp)
    8000310a:	e022                	sd	s0,0(sp)
    8000310c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000310e:	4639                	li	a2,14
    80003110:	ffffd097          	auipc	ra,0xffffd
    80003114:	13a080e7          	jalr	314(ra) # 8000024a <strncmp>
}
    80003118:	60a2                	ld	ra,8(sp)
    8000311a:	6402                	ld	s0,0(sp)
    8000311c:	0141                	addi	sp,sp,16
    8000311e:	8082                	ret

0000000080003120 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003120:	7139                	addi	sp,sp,-64
    80003122:	fc06                	sd	ra,56(sp)
    80003124:	f822                	sd	s0,48(sp)
    80003126:	f426                	sd	s1,40(sp)
    80003128:	f04a                	sd	s2,32(sp)
    8000312a:	ec4e                	sd	s3,24(sp)
    8000312c:	e852                	sd	s4,16(sp)
    8000312e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003130:	04451703          	lh	a4,68(a0)
    80003134:	4785                	li	a5,1
    80003136:	00f71a63          	bne	a4,a5,8000314a <dirlookup+0x2a>
    8000313a:	892a                	mv	s2,a0
    8000313c:	89ae                	mv	s3,a1
    8000313e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003140:	457c                	lw	a5,76(a0)
    80003142:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003144:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003146:	e79d                	bnez	a5,80003174 <dirlookup+0x54>
    80003148:	a8a5                	j	800031c0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000314a:	00005517          	auipc	a0,0x5
    8000314e:	44650513          	addi	a0,a0,1094 # 80008590 <syscalls+0x1c0>
    80003152:	00003097          	auipc	ra,0x3
    80003156:	baa080e7          	jalr	-1110(ra) # 80005cfc <panic>
      panic("dirlookup read");
    8000315a:	00005517          	auipc	a0,0x5
    8000315e:	44e50513          	addi	a0,a0,1102 # 800085a8 <syscalls+0x1d8>
    80003162:	00003097          	auipc	ra,0x3
    80003166:	b9a080e7          	jalr	-1126(ra) # 80005cfc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316a:	24c1                	addiw	s1,s1,16
    8000316c:	04c92783          	lw	a5,76(s2)
    80003170:	04f4f763          	bgeu	s1,a5,800031be <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003174:	4741                	li	a4,16
    80003176:	86a6                	mv	a3,s1
    80003178:	fc040613          	addi	a2,s0,-64
    8000317c:	4581                	li	a1,0
    8000317e:	854a                	mv	a0,s2
    80003180:	00000097          	auipc	ra,0x0
    80003184:	d70080e7          	jalr	-656(ra) # 80002ef0 <readi>
    80003188:	47c1                	li	a5,16
    8000318a:	fcf518e3          	bne	a0,a5,8000315a <dirlookup+0x3a>
    if(de.inum == 0)
    8000318e:	fc045783          	lhu	a5,-64(s0)
    80003192:	dfe1                	beqz	a5,8000316a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003194:	fc240593          	addi	a1,s0,-62
    80003198:	854e                	mv	a0,s3
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	f6c080e7          	jalr	-148(ra) # 80003106 <namecmp>
    800031a2:	f561                	bnez	a0,8000316a <dirlookup+0x4a>
      if(poff)
    800031a4:	000a0463          	beqz	s4,800031ac <dirlookup+0x8c>
        *poff = off;
    800031a8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ac:	fc045583          	lhu	a1,-64(s0)
    800031b0:	00092503          	lw	a0,0(s2)
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	74e080e7          	jalr	1870(ra) # 80002902 <iget>
    800031bc:	a011                	j	800031c0 <dirlookup+0xa0>
  return 0;
    800031be:	4501                	li	a0,0
}
    800031c0:	70e2                	ld	ra,56(sp)
    800031c2:	7442                	ld	s0,48(sp)
    800031c4:	74a2                	ld	s1,40(sp)
    800031c6:	7902                	ld	s2,32(sp)
    800031c8:	69e2                	ld	s3,24(sp)
    800031ca:	6a42                	ld	s4,16(sp)
    800031cc:	6121                	addi	sp,sp,64
    800031ce:	8082                	ret

00000000800031d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031d0:	711d                	addi	sp,sp,-96
    800031d2:	ec86                	sd	ra,88(sp)
    800031d4:	e8a2                	sd	s0,80(sp)
    800031d6:	e4a6                	sd	s1,72(sp)
    800031d8:	e0ca                	sd	s2,64(sp)
    800031da:	fc4e                	sd	s3,56(sp)
    800031dc:	f852                	sd	s4,48(sp)
    800031de:	f456                	sd	s5,40(sp)
    800031e0:	f05a                	sd	s6,32(sp)
    800031e2:	ec5e                	sd	s7,24(sp)
    800031e4:	e862                	sd	s8,16(sp)
    800031e6:	e466                	sd	s9,8(sp)
    800031e8:	e06a                	sd	s10,0(sp)
    800031ea:	1080                	addi	s0,sp,96
    800031ec:	84aa                	mv	s1,a0
    800031ee:	8b2e                	mv	s6,a1
    800031f0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031f2:	00054703          	lbu	a4,0(a0)
    800031f6:	02f00793          	li	a5,47
    800031fa:	02f70363          	beq	a4,a5,80003220 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031fe:	ffffe097          	auipc	ra,0xffffe
    80003202:	c54080e7          	jalr	-940(ra) # 80000e52 <myproc>
    80003206:	29053503          	ld	a0,656(a0)
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	9f4080e7          	jalr	-1548(ra) # 80002bfe <idup>
    80003212:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003214:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003218:	4cb5                	li	s9,13
  len = path - s;
    8000321a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000321c:	4c05                	li	s8,1
    8000321e:	a87d                	j	800032dc <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003220:	4585                	li	a1,1
    80003222:	4505                	li	a0,1
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	6de080e7          	jalr	1758(ra) # 80002902 <iget>
    8000322c:	8a2a                	mv	s4,a0
    8000322e:	b7dd                	j	80003214 <namex+0x44>
      iunlockput(ip);
    80003230:	8552                	mv	a0,s4
    80003232:	00000097          	auipc	ra,0x0
    80003236:	c6c080e7          	jalr	-916(ra) # 80002e9e <iunlockput>
      return 0;
    8000323a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000323c:	8552                	mv	a0,s4
    8000323e:	60e6                	ld	ra,88(sp)
    80003240:	6446                	ld	s0,80(sp)
    80003242:	64a6                	ld	s1,72(sp)
    80003244:	6906                	ld	s2,64(sp)
    80003246:	79e2                	ld	s3,56(sp)
    80003248:	7a42                	ld	s4,48(sp)
    8000324a:	7aa2                	ld	s5,40(sp)
    8000324c:	7b02                	ld	s6,32(sp)
    8000324e:	6be2                	ld	s7,24(sp)
    80003250:	6c42                	ld	s8,16(sp)
    80003252:	6ca2                	ld	s9,8(sp)
    80003254:	6d02                	ld	s10,0(sp)
    80003256:	6125                	addi	sp,sp,96
    80003258:	8082                	ret
      iunlock(ip);
    8000325a:	8552                	mv	a0,s4
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	aa2080e7          	jalr	-1374(ra) # 80002cfe <iunlock>
      return ip;
    80003264:	bfe1                	j	8000323c <namex+0x6c>
      iunlockput(ip);
    80003266:	8552                	mv	a0,s4
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	c36080e7          	jalr	-970(ra) # 80002e9e <iunlockput>
      return 0;
    80003270:	8a4e                	mv	s4,s3
    80003272:	b7e9                	j	8000323c <namex+0x6c>
  len = path - s;
    80003274:	40998633          	sub	a2,s3,s1
    80003278:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000327c:	09acd863          	bge	s9,s10,8000330c <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003280:	4639                	li	a2,14
    80003282:	85a6                	mv	a1,s1
    80003284:	8556                	mv	a0,s5
    80003286:	ffffd097          	auipc	ra,0xffffd
    8000328a:	f50080e7          	jalr	-176(ra) # 800001d6 <memmove>
    8000328e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	01279763          	bne	a5,s2,800032a2 <namex+0xd2>
    path++;
    80003298:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000329a:	0004c783          	lbu	a5,0(s1)
    8000329e:	ff278de3          	beq	a5,s2,80003298 <namex+0xc8>
    ilock(ip);
    800032a2:	8552                	mv	a0,s4
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	998080e7          	jalr	-1640(ra) # 80002c3c <ilock>
    if(ip->type != T_DIR){
    800032ac:	044a1783          	lh	a5,68(s4)
    800032b0:	f98790e3          	bne	a5,s8,80003230 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800032b4:	000b0563          	beqz	s6,800032be <namex+0xee>
    800032b8:	0004c783          	lbu	a5,0(s1)
    800032bc:	dfd9                	beqz	a5,8000325a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032be:	865e                	mv	a2,s7
    800032c0:	85d6                	mv	a1,s5
    800032c2:	8552                	mv	a0,s4
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	e5c080e7          	jalr	-420(ra) # 80003120 <dirlookup>
    800032cc:	89aa                	mv	s3,a0
    800032ce:	dd41                	beqz	a0,80003266 <namex+0x96>
    iunlockput(ip);
    800032d0:	8552                	mv	a0,s4
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	bcc080e7          	jalr	-1076(ra) # 80002e9e <iunlockput>
    ip = next;
    800032da:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032dc:	0004c783          	lbu	a5,0(s1)
    800032e0:	01279763          	bne	a5,s2,800032ee <namex+0x11e>
    path++;
    800032e4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e6:	0004c783          	lbu	a5,0(s1)
    800032ea:	ff278de3          	beq	a5,s2,800032e4 <namex+0x114>
  if(*path == 0)
    800032ee:	cb9d                	beqz	a5,80003324 <namex+0x154>
  while(*path != '/' && *path != 0)
    800032f0:	0004c783          	lbu	a5,0(s1)
    800032f4:	89a6                	mv	s3,s1
  len = path - s;
    800032f6:	8d5e                	mv	s10,s7
    800032f8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032fa:	01278963          	beq	a5,s2,8000330c <namex+0x13c>
    800032fe:	dbbd                	beqz	a5,80003274 <namex+0xa4>
    path++;
    80003300:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003302:	0009c783          	lbu	a5,0(s3)
    80003306:	ff279ce3          	bne	a5,s2,800032fe <namex+0x12e>
    8000330a:	b7ad                	j	80003274 <namex+0xa4>
    memmove(name, s, len);
    8000330c:	2601                	sext.w	a2,a2
    8000330e:	85a6                	mv	a1,s1
    80003310:	8556                	mv	a0,s5
    80003312:	ffffd097          	auipc	ra,0xffffd
    80003316:	ec4080e7          	jalr	-316(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000331a:	9d56                	add	s10,s10,s5
    8000331c:	000d0023          	sb	zero,0(s10)
    80003320:	84ce                	mv	s1,s3
    80003322:	b7bd                	j	80003290 <namex+0xc0>
  if(nameiparent){
    80003324:	f00b0ce3          	beqz	s6,8000323c <namex+0x6c>
    iput(ip);
    80003328:	8552                	mv	a0,s4
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	acc080e7          	jalr	-1332(ra) # 80002df6 <iput>
    return 0;
    80003332:	4a01                	li	s4,0
    80003334:	b721                	j	8000323c <namex+0x6c>

0000000080003336 <dirlink>:
{
    80003336:	7139                	addi	sp,sp,-64
    80003338:	fc06                	sd	ra,56(sp)
    8000333a:	f822                	sd	s0,48(sp)
    8000333c:	f426                	sd	s1,40(sp)
    8000333e:	f04a                	sd	s2,32(sp)
    80003340:	ec4e                	sd	s3,24(sp)
    80003342:	e852                	sd	s4,16(sp)
    80003344:	0080                	addi	s0,sp,64
    80003346:	892a                	mv	s2,a0
    80003348:	8a2e                	mv	s4,a1
    8000334a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000334c:	4601                	li	a2,0
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	dd2080e7          	jalr	-558(ra) # 80003120 <dirlookup>
    80003356:	e93d                	bnez	a0,800033cc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003358:	04c92483          	lw	s1,76(s2)
    8000335c:	c49d                	beqz	s1,8000338a <dirlink+0x54>
    8000335e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003360:	4741                	li	a4,16
    80003362:	86a6                	mv	a3,s1
    80003364:	fc040613          	addi	a2,s0,-64
    80003368:	4581                	li	a1,0
    8000336a:	854a                	mv	a0,s2
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	b84080e7          	jalr	-1148(ra) # 80002ef0 <readi>
    80003374:	47c1                	li	a5,16
    80003376:	06f51163          	bne	a0,a5,800033d8 <dirlink+0xa2>
    if(de.inum == 0)
    8000337a:	fc045783          	lhu	a5,-64(s0)
    8000337e:	c791                	beqz	a5,8000338a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003380:	24c1                	addiw	s1,s1,16
    80003382:	04c92783          	lw	a5,76(s2)
    80003386:	fcf4ede3          	bltu	s1,a5,80003360 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000338a:	4639                	li	a2,14
    8000338c:	85d2                	mv	a1,s4
    8000338e:	fc240513          	addi	a0,s0,-62
    80003392:	ffffd097          	auipc	ra,0xffffd
    80003396:	ef4080e7          	jalr	-268(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000339a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339e:	4741                	li	a4,16
    800033a0:	86a6                	mv	a3,s1
    800033a2:	fc040613          	addi	a2,s0,-64
    800033a6:	4581                	li	a1,0
    800033a8:	854a                	mv	a0,s2
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	c3e080e7          	jalr	-962(ra) # 80002fe8 <writei>
    800033b2:	1541                	addi	a0,a0,-16
    800033b4:	00a03533          	snez	a0,a0
    800033b8:	40a00533          	neg	a0,a0
}
    800033bc:	70e2                	ld	ra,56(sp)
    800033be:	7442                	ld	s0,48(sp)
    800033c0:	74a2                	ld	s1,40(sp)
    800033c2:	7902                	ld	s2,32(sp)
    800033c4:	69e2                	ld	s3,24(sp)
    800033c6:	6a42                	ld	s4,16(sp)
    800033c8:	6121                	addi	sp,sp,64
    800033ca:	8082                	ret
    iput(ip);
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	a2a080e7          	jalr	-1494(ra) # 80002df6 <iput>
    return -1;
    800033d4:	557d                	li	a0,-1
    800033d6:	b7dd                	j	800033bc <dirlink+0x86>
      panic("dirlink read");
    800033d8:	00005517          	auipc	a0,0x5
    800033dc:	1e050513          	addi	a0,a0,480 # 800085b8 <syscalls+0x1e8>
    800033e0:	00003097          	auipc	ra,0x3
    800033e4:	91c080e7          	jalr	-1764(ra) # 80005cfc <panic>

00000000800033e8 <namei>:

struct inode*
namei(char *path)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033f0:	fe040613          	addi	a2,s0,-32
    800033f4:	4581                	li	a1,0
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	dda080e7          	jalr	-550(ra) # 800031d0 <namex>
}
    800033fe:	60e2                	ld	ra,24(sp)
    80003400:	6442                	ld	s0,16(sp)
    80003402:	6105                	addi	sp,sp,32
    80003404:	8082                	ret

0000000080003406 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003406:	1141                	addi	sp,sp,-16
    80003408:	e406                	sd	ra,8(sp)
    8000340a:	e022                	sd	s0,0(sp)
    8000340c:	0800                	addi	s0,sp,16
    8000340e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003410:	4585                	li	a1,1
    80003412:	00000097          	auipc	ra,0x0
    80003416:	dbe080e7          	jalr	-578(ra) # 800031d0 <namex>
}
    8000341a:	60a2                	ld	ra,8(sp)
    8000341c:	6402                	ld	s0,0(sp)
    8000341e:	0141                	addi	sp,sp,16
    80003420:	8082                	ret

0000000080003422 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003422:	1101                	addi	sp,sp,-32
    80003424:	ec06                	sd	ra,24(sp)
    80003426:	e822                	sd	s0,16(sp)
    80003428:	e426                	sd	s1,8(sp)
    8000342a:	e04a                	sd	s2,0(sp)
    8000342c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000342e:	0001a917          	auipc	s2,0x1a
    80003432:	4d290913          	addi	s2,s2,1234 # 8001d900 <log>
    80003436:	01892583          	lw	a1,24(s2)
    8000343a:	02892503          	lw	a0,40(s2)
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	fe6080e7          	jalr	-26(ra) # 80002424 <bread>
    80003446:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003448:	02c92683          	lw	a3,44(s2)
    8000344c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000344e:	02d05863          	blez	a3,8000347e <write_head+0x5c>
    80003452:	0001a797          	auipc	a5,0x1a
    80003456:	4de78793          	addi	a5,a5,1246 # 8001d930 <log+0x30>
    8000345a:	05c50713          	addi	a4,a0,92
    8000345e:	36fd                	addiw	a3,a3,-1
    80003460:	02069613          	slli	a2,a3,0x20
    80003464:	01e65693          	srli	a3,a2,0x1e
    80003468:	0001a617          	auipc	a2,0x1a
    8000346c:	4cc60613          	addi	a2,a2,1228 # 8001d934 <log+0x34>
    80003470:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003472:	4390                	lw	a2,0(a5)
    80003474:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003476:	0791                	addi	a5,a5,4
    80003478:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000347a:	fed79ce3          	bne	a5,a3,80003472 <write_head+0x50>
  }
  bwrite(buf);
    8000347e:	8526                	mv	a0,s1
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	096080e7          	jalr	150(ra) # 80002516 <bwrite>
  brelse(buf);
    80003488:	8526                	mv	a0,s1
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	0ca080e7          	jalr	202(ra) # 80002554 <brelse>
}
    80003492:	60e2                	ld	ra,24(sp)
    80003494:	6442                	ld	s0,16(sp)
    80003496:	64a2                	ld	s1,8(sp)
    80003498:	6902                	ld	s2,0(sp)
    8000349a:	6105                	addi	sp,sp,32
    8000349c:	8082                	ret

000000008000349e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349e:	0001a797          	auipc	a5,0x1a
    800034a2:	48e7a783          	lw	a5,1166(a5) # 8001d92c <log+0x2c>
    800034a6:	0af05d63          	blez	a5,80003560 <install_trans+0xc2>
{
    800034aa:	7139                	addi	sp,sp,-64
    800034ac:	fc06                	sd	ra,56(sp)
    800034ae:	f822                	sd	s0,48(sp)
    800034b0:	f426                	sd	s1,40(sp)
    800034b2:	f04a                	sd	s2,32(sp)
    800034b4:	ec4e                	sd	s3,24(sp)
    800034b6:	e852                	sd	s4,16(sp)
    800034b8:	e456                	sd	s5,8(sp)
    800034ba:	e05a                	sd	s6,0(sp)
    800034bc:	0080                	addi	s0,sp,64
    800034be:	8b2a                	mv	s6,a0
    800034c0:	0001aa97          	auipc	s5,0x1a
    800034c4:	470a8a93          	addi	s5,s5,1136 # 8001d930 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ca:	0001a997          	auipc	s3,0x1a
    800034ce:	43698993          	addi	s3,s3,1078 # 8001d900 <log>
    800034d2:	a00d                	j	800034f4 <install_trans+0x56>
    brelse(lbuf);
    800034d4:	854a                	mv	a0,s2
    800034d6:	fffff097          	auipc	ra,0xfffff
    800034da:	07e080e7          	jalr	126(ra) # 80002554 <brelse>
    brelse(dbuf);
    800034de:	8526                	mv	a0,s1
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	074080e7          	jalr	116(ra) # 80002554 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e8:	2a05                	addiw	s4,s4,1
    800034ea:	0a91                	addi	s5,s5,4
    800034ec:	02c9a783          	lw	a5,44(s3)
    800034f0:	04fa5e63          	bge	s4,a5,8000354c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f4:	0189a583          	lw	a1,24(s3)
    800034f8:	014585bb          	addw	a1,a1,s4
    800034fc:	2585                	addiw	a1,a1,1
    800034fe:	0289a503          	lw	a0,40(s3)
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	f22080e7          	jalr	-222(ra) # 80002424 <bread>
    8000350a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000350c:	000aa583          	lw	a1,0(s5)
    80003510:	0289a503          	lw	a0,40(s3)
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	f10080e7          	jalr	-240(ra) # 80002424 <bread>
    8000351c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000351e:	40000613          	li	a2,1024
    80003522:	05890593          	addi	a1,s2,88
    80003526:	05850513          	addi	a0,a0,88
    8000352a:	ffffd097          	auipc	ra,0xffffd
    8000352e:	cac080e7          	jalr	-852(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003532:	8526                	mv	a0,s1
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	fe2080e7          	jalr	-30(ra) # 80002516 <bwrite>
    if(recovering == 0)
    8000353c:	f80b1ce3          	bnez	s6,800034d4 <install_trans+0x36>
      bunpin(dbuf);
    80003540:	8526                	mv	a0,s1
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	0ec080e7          	jalr	236(ra) # 8000262e <bunpin>
    8000354a:	b769                	j	800034d4 <install_trans+0x36>
}
    8000354c:	70e2                	ld	ra,56(sp)
    8000354e:	7442                	ld	s0,48(sp)
    80003550:	74a2                	ld	s1,40(sp)
    80003552:	7902                	ld	s2,32(sp)
    80003554:	69e2                	ld	s3,24(sp)
    80003556:	6a42                	ld	s4,16(sp)
    80003558:	6aa2                	ld	s5,8(sp)
    8000355a:	6b02                	ld	s6,0(sp)
    8000355c:	6121                	addi	sp,sp,64
    8000355e:	8082                	ret
    80003560:	8082                	ret

0000000080003562 <initlog>:
{
    80003562:	7179                	addi	sp,sp,-48
    80003564:	f406                	sd	ra,40(sp)
    80003566:	f022                	sd	s0,32(sp)
    80003568:	ec26                	sd	s1,24(sp)
    8000356a:	e84a                	sd	s2,16(sp)
    8000356c:	e44e                	sd	s3,8(sp)
    8000356e:	1800                	addi	s0,sp,48
    80003570:	892a                	mv	s2,a0
    80003572:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003574:	0001a497          	auipc	s1,0x1a
    80003578:	38c48493          	addi	s1,s1,908 # 8001d900 <log>
    8000357c:	00005597          	auipc	a1,0x5
    80003580:	04c58593          	addi	a1,a1,76 # 800085c8 <syscalls+0x1f8>
    80003584:	8526                	mv	a0,s1
    80003586:	00003097          	auipc	ra,0x3
    8000358a:	c6a080e7          	jalr	-918(ra) # 800061f0 <initlock>
  log.start = sb->logstart;
    8000358e:	0149a583          	lw	a1,20(s3)
    80003592:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003594:	0109a783          	lw	a5,16(s3)
    80003598:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000359a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000359e:	854a                	mv	a0,s2
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	e84080e7          	jalr	-380(ra) # 80002424 <bread>
  log.lh.n = lh->n;
    800035a8:	4d34                	lw	a3,88(a0)
    800035aa:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035ac:	02d05663          	blez	a3,800035d8 <initlog+0x76>
    800035b0:	05c50793          	addi	a5,a0,92
    800035b4:	0001a717          	auipc	a4,0x1a
    800035b8:	37c70713          	addi	a4,a4,892 # 8001d930 <log+0x30>
    800035bc:	36fd                	addiw	a3,a3,-1
    800035be:	02069613          	slli	a2,a3,0x20
    800035c2:	01e65693          	srli	a3,a2,0x1e
    800035c6:	06050613          	addi	a2,a0,96
    800035ca:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035cc:	4390                	lw	a2,0(a5)
    800035ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035d0:	0791                	addi	a5,a5,4
    800035d2:	0711                	addi	a4,a4,4
    800035d4:	fed79ce3          	bne	a5,a3,800035cc <initlog+0x6a>
  brelse(buf);
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	f7c080e7          	jalr	-132(ra) # 80002554 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035e0:	4505                	li	a0,1
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	ebc080e7          	jalr	-324(ra) # 8000349e <install_trans>
  log.lh.n = 0;
    800035ea:	0001a797          	auipc	a5,0x1a
    800035ee:	3407a123          	sw	zero,834(a5) # 8001d92c <log+0x2c>
  write_head(); // clear the log
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	e30080e7          	jalr	-464(ra) # 80003422 <write_head>
}
    800035fa:	70a2                	ld	ra,40(sp)
    800035fc:	7402                	ld	s0,32(sp)
    800035fe:	64e2                	ld	s1,24(sp)
    80003600:	6942                	ld	s2,16(sp)
    80003602:	69a2                	ld	s3,8(sp)
    80003604:	6145                	addi	sp,sp,48
    80003606:	8082                	ret

0000000080003608 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003608:	1101                	addi	sp,sp,-32
    8000360a:	ec06                	sd	ra,24(sp)
    8000360c:	e822                	sd	s0,16(sp)
    8000360e:	e426                	sd	s1,8(sp)
    80003610:	e04a                	sd	s2,0(sp)
    80003612:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003614:	0001a517          	auipc	a0,0x1a
    80003618:	2ec50513          	addi	a0,a0,748 # 8001d900 <log>
    8000361c:	00003097          	auipc	ra,0x3
    80003620:	c64080e7          	jalr	-924(ra) # 80006280 <acquire>
  while(1){
    if(log.committing){
    80003624:	0001a497          	auipc	s1,0x1a
    80003628:	2dc48493          	addi	s1,s1,732 # 8001d900 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000362c:	4979                	li	s2,30
    8000362e:	a039                	j	8000363c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003630:	85a6                	mv	a1,s1
    80003632:	8526                	mv	a0,s1
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	efa080e7          	jalr	-262(ra) # 8000152e <sleep>
    if(log.committing){
    8000363c:	50dc                	lw	a5,36(s1)
    8000363e:	fbed                	bnez	a5,80003630 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003640:	5098                	lw	a4,32(s1)
    80003642:	2705                	addiw	a4,a4,1
    80003644:	0007069b          	sext.w	a3,a4
    80003648:	0027179b          	slliw	a5,a4,0x2
    8000364c:	9fb9                	addw	a5,a5,a4
    8000364e:	0017979b          	slliw	a5,a5,0x1
    80003652:	54d8                	lw	a4,44(s1)
    80003654:	9fb9                	addw	a5,a5,a4
    80003656:	00f95963          	bge	s2,a5,80003668 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000365a:	85a6                	mv	a1,s1
    8000365c:	8526                	mv	a0,s1
    8000365e:	ffffe097          	auipc	ra,0xffffe
    80003662:	ed0080e7          	jalr	-304(ra) # 8000152e <sleep>
    80003666:	bfd9                	j	8000363c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003668:	0001a517          	auipc	a0,0x1a
    8000366c:	29850513          	addi	a0,a0,664 # 8001d900 <log>
    80003670:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003672:	00003097          	auipc	ra,0x3
    80003676:	cc2080e7          	jalr	-830(ra) # 80006334 <release>
      break;
    }
  }
}
    8000367a:	60e2                	ld	ra,24(sp)
    8000367c:	6442                	ld	s0,16(sp)
    8000367e:	64a2                	ld	s1,8(sp)
    80003680:	6902                	ld	s2,0(sp)
    80003682:	6105                	addi	sp,sp,32
    80003684:	8082                	ret

0000000080003686 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003686:	7139                	addi	sp,sp,-64
    80003688:	fc06                	sd	ra,56(sp)
    8000368a:	f822                	sd	s0,48(sp)
    8000368c:	f426                	sd	s1,40(sp)
    8000368e:	f04a                	sd	s2,32(sp)
    80003690:	ec4e                	sd	s3,24(sp)
    80003692:	e852                	sd	s4,16(sp)
    80003694:	e456                	sd	s5,8(sp)
    80003696:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003698:	0001a497          	auipc	s1,0x1a
    8000369c:	26848493          	addi	s1,s1,616 # 8001d900 <log>
    800036a0:	8526                	mv	a0,s1
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	bde080e7          	jalr	-1058(ra) # 80006280 <acquire>
  log.outstanding -= 1;
    800036aa:	509c                	lw	a5,32(s1)
    800036ac:	37fd                	addiw	a5,a5,-1
    800036ae:	0007891b          	sext.w	s2,a5
    800036b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036b4:	50dc                	lw	a5,36(s1)
    800036b6:	e7b9                	bnez	a5,80003704 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036b8:	04091e63          	bnez	s2,80003714 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036bc:	0001a497          	auipc	s1,0x1a
    800036c0:	24448493          	addi	s1,s1,580 # 8001d900 <log>
    800036c4:	4785                	li	a5,1
    800036c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036c8:	8526                	mv	a0,s1
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	c6a080e7          	jalr	-918(ra) # 80006334 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036d2:	54dc                	lw	a5,44(s1)
    800036d4:	06f04763          	bgtz	a5,80003742 <end_op+0xbc>
    acquire(&log.lock);
    800036d8:	0001a497          	auipc	s1,0x1a
    800036dc:	22848493          	addi	s1,s1,552 # 8001d900 <log>
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	b9e080e7          	jalr	-1122(ra) # 80006280 <acquire>
    log.committing = 0;
    800036ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036ee:	8526                	mv	a0,s1
    800036f0:	ffffe097          	auipc	ra,0xffffe
    800036f4:	ea2080e7          	jalr	-350(ra) # 80001592 <wakeup>
    release(&log.lock);
    800036f8:	8526                	mv	a0,s1
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	c3a080e7          	jalr	-966(ra) # 80006334 <release>
}
    80003702:	a03d                	j	80003730 <end_op+0xaa>
    panic("log.committing");
    80003704:	00005517          	auipc	a0,0x5
    80003708:	ecc50513          	addi	a0,a0,-308 # 800085d0 <syscalls+0x200>
    8000370c:	00002097          	auipc	ra,0x2
    80003710:	5f0080e7          	jalr	1520(ra) # 80005cfc <panic>
    wakeup(&log);
    80003714:	0001a497          	auipc	s1,0x1a
    80003718:	1ec48493          	addi	s1,s1,492 # 8001d900 <log>
    8000371c:	8526                	mv	a0,s1
    8000371e:	ffffe097          	auipc	ra,0xffffe
    80003722:	e74080e7          	jalr	-396(ra) # 80001592 <wakeup>
  release(&log.lock);
    80003726:	8526                	mv	a0,s1
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	c0c080e7          	jalr	-1012(ra) # 80006334 <release>
}
    80003730:	70e2                	ld	ra,56(sp)
    80003732:	7442                	ld	s0,48(sp)
    80003734:	74a2                	ld	s1,40(sp)
    80003736:	7902                	ld	s2,32(sp)
    80003738:	69e2                	ld	s3,24(sp)
    8000373a:	6a42                	ld	s4,16(sp)
    8000373c:	6aa2                	ld	s5,8(sp)
    8000373e:	6121                	addi	sp,sp,64
    80003740:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003742:	0001aa97          	auipc	s5,0x1a
    80003746:	1eea8a93          	addi	s5,s5,494 # 8001d930 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000374a:	0001aa17          	auipc	s4,0x1a
    8000374e:	1b6a0a13          	addi	s4,s4,438 # 8001d900 <log>
    80003752:	018a2583          	lw	a1,24(s4)
    80003756:	012585bb          	addw	a1,a1,s2
    8000375a:	2585                	addiw	a1,a1,1
    8000375c:	028a2503          	lw	a0,40(s4)
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	cc4080e7          	jalr	-828(ra) # 80002424 <bread>
    80003768:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000376a:	000aa583          	lw	a1,0(s5)
    8000376e:	028a2503          	lw	a0,40(s4)
    80003772:	fffff097          	auipc	ra,0xfffff
    80003776:	cb2080e7          	jalr	-846(ra) # 80002424 <bread>
    8000377a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000377c:	40000613          	li	a2,1024
    80003780:	05850593          	addi	a1,a0,88
    80003784:	05848513          	addi	a0,s1,88
    80003788:	ffffd097          	auipc	ra,0xffffd
    8000378c:	a4e080e7          	jalr	-1458(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003790:	8526                	mv	a0,s1
    80003792:	fffff097          	auipc	ra,0xfffff
    80003796:	d84080e7          	jalr	-636(ra) # 80002516 <bwrite>
    brelse(from);
    8000379a:	854e                	mv	a0,s3
    8000379c:	fffff097          	auipc	ra,0xfffff
    800037a0:	db8080e7          	jalr	-584(ra) # 80002554 <brelse>
    brelse(to);
    800037a4:	8526                	mv	a0,s1
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	dae080e7          	jalr	-594(ra) # 80002554 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ae:	2905                	addiw	s2,s2,1
    800037b0:	0a91                	addi	s5,s5,4
    800037b2:	02ca2783          	lw	a5,44(s4)
    800037b6:	f8f94ee3          	blt	s2,a5,80003752 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	c68080e7          	jalr	-920(ra) # 80003422 <write_head>
    install_trans(0); // Now install writes to home locations
    800037c2:	4501                	li	a0,0
    800037c4:	00000097          	auipc	ra,0x0
    800037c8:	cda080e7          	jalr	-806(ra) # 8000349e <install_trans>
    log.lh.n = 0;
    800037cc:	0001a797          	auipc	a5,0x1a
    800037d0:	1607a023          	sw	zero,352(a5) # 8001d92c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037d4:	00000097          	auipc	ra,0x0
    800037d8:	c4e080e7          	jalr	-946(ra) # 80003422 <write_head>
    800037dc:	bdf5                	j	800036d8 <end_op+0x52>

00000000800037de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037de:	1101                	addi	sp,sp,-32
    800037e0:	ec06                	sd	ra,24(sp)
    800037e2:	e822                	sd	s0,16(sp)
    800037e4:	e426                	sd	s1,8(sp)
    800037e6:	e04a                	sd	s2,0(sp)
    800037e8:	1000                	addi	s0,sp,32
    800037ea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037ec:	0001a917          	auipc	s2,0x1a
    800037f0:	11490913          	addi	s2,s2,276 # 8001d900 <log>
    800037f4:	854a                	mv	a0,s2
    800037f6:	00003097          	auipc	ra,0x3
    800037fa:	a8a080e7          	jalr	-1398(ra) # 80006280 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037fe:	02c92603          	lw	a2,44(s2)
    80003802:	47f5                	li	a5,29
    80003804:	06c7c563          	blt	a5,a2,8000386e <log_write+0x90>
    80003808:	0001a797          	auipc	a5,0x1a
    8000380c:	1147a783          	lw	a5,276(a5) # 8001d91c <log+0x1c>
    80003810:	37fd                	addiw	a5,a5,-1
    80003812:	04f65e63          	bge	a2,a5,8000386e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003816:	0001a797          	auipc	a5,0x1a
    8000381a:	10a7a783          	lw	a5,266(a5) # 8001d920 <log+0x20>
    8000381e:	06f05063          	blez	a5,8000387e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003822:	4781                	li	a5,0
    80003824:	06c05563          	blez	a2,8000388e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003828:	44cc                	lw	a1,12(s1)
    8000382a:	0001a717          	auipc	a4,0x1a
    8000382e:	10670713          	addi	a4,a4,262 # 8001d930 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003832:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003834:	4314                	lw	a3,0(a4)
    80003836:	04b68c63          	beq	a3,a1,8000388e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000383a:	2785                	addiw	a5,a5,1
    8000383c:	0711                	addi	a4,a4,4
    8000383e:	fef61be3          	bne	a2,a5,80003834 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003842:	0621                	addi	a2,a2,8
    80003844:	060a                	slli	a2,a2,0x2
    80003846:	0001a797          	auipc	a5,0x1a
    8000384a:	0ba78793          	addi	a5,a5,186 # 8001d900 <log>
    8000384e:	97b2                	add	a5,a5,a2
    80003850:	44d8                	lw	a4,12(s1)
    80003852:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003854:	8526                	mv	a0,s1
    80003856:	fffff097          	auipc	ra,0xfffff
    8000385a:	d9c080e7          	jalr	-612(ra) # 800025f2 <bpin>
    log.lh.n++;
    8000385e:	0001a717          	auipc	a4,0x1a
    80003862:	0a270713          	addi	a4,a4,162 # 8001d900 <log>
    80003866:	575c                	lw	a5,44(a4)
    80003868:	2785                	addiw	a5,a5,1
    8000386a:	d75c                	sw	a5,44(a4)
    8000386c:	a82d                	j	800038a6 <log_write+0xc8>
    panic("too big a transaction");
    8000386e:	00005517          	auipc	a0,0x5
    80003872:	d7250513          	addi	a0,a0,-654 # 800085e0 <syscalls+0x210>
    80003876:	00002097          	auipc	ra,0x2
    8000387a:	486080e7          	jalr	1158(ra) # 80005cfc <panic>
    panic("log_write outside of trans");
    8000387e:	00005517          	auipc	a0,0x5
    80003882:	d7a50513          	addi	a0,a0,-646 # 800085f8 <syscalls+0x228>
    80003886:	00002097          	auipc	ra,0x2
    8000388a:	476080e7          	jalr	1142(ra) # 80005cfc <panic>
  log.lh.block[i] = b->blockno;
    8000388e:	00878693          	addi	a3,a5,8
    80003892:	068a                	slli	a3,a3,0x2
    80003894:	0001a717          	auipc	a4,0x1a
    80003898:	06c70713          	addi	a4,a4,108 # 8001d900 <log>
    8000389c:	9736                	add	a4,a4,a3
    8000389e:	44d4                	lw	a3,12(s1)
    800038a0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038a2:	faf609e3          	beq	a2,a5,80003854 <log_write+0x76>
  }
  release(&log.lock);
    800038a6:	0001a517          	auipc	a0,0x1a
    800038aa:	05a50513          	addi	a0,a0,90 # 8001d900 <log>
    800038ae:	00003097          	auipc	ra,0x3
    800038b2:	a86080e7          	jalr	-1402(ra) # 80006334 <release>
}
    800038b6:	60e2                	ld	ra,24(sp)
    800038b8:	6442                	ld	s0,16(sp)
    800038ba:	64a2                	ld	s1,8(sp)
    800038bc:	6902                	ld	s2,0(sp)
    800038be:	6105                	addi	sp,sp,32
    800038c0:	8082                	ret

00000000800038c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038c2:	1101                	addi	sp,sp,-32
    800038c4:	ec06                	sd	ra,24(sp)
    800038c6:	e822                	sd	s0,16(sp)
    800038c8:	e426                	sd	s1,8(sp)
    800038ca:	e04a                	sd	s2,0(sp)
    800038cc:	1000                	addi	s0,sp,32
    800038ce:	84aa                	mv	s1,a0
    800038d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038d2:	00005597          	auipc	a1,0x5
    800038d6:	d4658593          	addi	a1,a1,-698 # 80008618 <syscalls+0x248>
    800038da:	0521                	addi	a0,a0,8
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	914080e7          	jalr	-1772(ra) # 800061f0 <initlock>
  lk->name = name;
    800038e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ec:	0204a423          	sw	zero,40(s1)
}
    800038f0:	60e2                	ld	ra,24(sp)
    800038f2:	6442                	ld	s0,16(sp)
    800038f4:	64a2                	ld	s1,8(sp)
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038fc:	1101                	addi	sp,sp,-32
    800038fe:	ec06                	sd	ra,24(sp)
    80003900:	e822                	sd	s0,16(sp)
    80003902:	e426                	sd	s1,8(sp)
    80003904:	e04a                	sd	s2,0(sp)
    80003906:	1000                	addi	s0,sp,32
    80003908:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000390a:	00850913          	addi	s2,a0,8
    8000390e:	854a                	mv	a0,s2
    80003910:	00003097          	auipc	ra,0x3
    80003914:	970080e7          	jalr	-1680(ra) # 80006280 <acquire>
  while (lk->locked) {
    80003918:	409c                	lw	a5,0(s1)
    8000391a:	cb89                	beqz	a5,8000392c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000391c:	85ca                	mv	a1,s2
    8000391e:	8526                	mv	a0,s1
    80003920:	ffffe097          	auipc	ra,0xffffe
    80003924:	c0e080e7          	jalr	-1010(ra) # 8000152e <sleep>
  while (lk->locked) {
    80003928:	409c                	lw	a5,0(s1)
    8000392a:	fbed                	bnez	a5,8000391c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000392c:	4785                	li	a5,1
    8000392e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003930:	ffffd097          	auipc	ra,0xffffd
    80003934:	522080e7          	jalr	1314(ra) # 80000e52 <myproc>
    80003938:	591c                	lw	a5,48(a0)
    8000393a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000393c:	854a                	mv	a0,s2
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	9f6080e7          	jalr	-1546(ra) # 80006334 <release>
}
    80003946:	60e2                	ld	ra,24(sp)
    80003948:	6442                	ld	s0,16(sp)
    8000394a:	64a2                	ld	s1,8(sp)
    8000394c:	6902                	ld	s2,0(sp)
    8000394e:	6105                	addi	sp,sp,32
    80003950:	8082                	ret

0000000080003952 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003952:	1101                	addi	sp,sp,-32
    80003954:	ec06                	sd	ra,24(sp)
    80003956:	e822                	sd	s0,16(sp)
    80003958:	e426                	sd	s1,8(sp)
    8000395a:	e04a                	sd	s2,0(sp)
    8000395c:	1000                	addi	s0,sp,32
    8000395e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003960:	00850913          	addi	s2,a0,8
    80003964:	854a                	mv	a0,s2
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	91a080e7          	jalr	-1766(ra) # 80006280 <acquire>
  lk->locked = 0;
    8000396e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003972:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003976:	8526                	mv	a0,s1
    80003978:	ffffe097          	auipc	ra,0xffffe
    8000397c:	c1a080e7          	jalr	-998(ra) # 80001592 <wakeup>
  release(&lk->lk);
    80003980:	854a                	mv	a0,s2
    80003982:	00003097          	auipc	ra,0x3
    80003986:	9b2080e7          	jalr	-1614(ra) # 80006334 <release>
}
    8000398a:	60e2                	ld	ra,24(sp)
    8000398c:	6442                	ld	s0,16(sp)
    8000398e:	64a2                	ld	s1,8(sp)
    80003990:	6902                	ld	s2,0(sp)
    80003992:	6105                	addi	sp,sp,32
    80003994:	8082                	ret

0000000080003996 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003996:	7179                	addi	sp,sp,-48
    80003998:	f406                	sd	ra,40(sp)
    8000399a:	f022                	sd	s0,32(sp)
    8000399c:	ec26                	sd	s1,24(sp)
    8000399e:	e84a                	sd	s2,16(sp)
    800039a0:	e44e                	sd	s3,8(sp)
    800039a2:	1800                	addi	s0,sp,48
    800039a4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039a6:	00850913          	addi	s2,a0,8
    800039aa:	854a                	mv	a0,s2
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	8d4080e7          	jalr	-1836(ra) # 80006280 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039b4:	409c                	lw	a5,0(s1)
    800039b6:	ef99                	bnez	a5,800039d4 <holdingsleep+0x3e>
    800039b8:	4481                	li	s1,0
  release(&lk->lk);
    800039ba:	854a                	mv	a0,s2
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	978080e7          	jalr	-1672(ra) # 80006334 <release>
  return r;
}
    800039c4:	8526                	mv	a0,s1
    800039c6:	70a2                	ld	ra,40(sp)
    800039c8:	7402                	ld	s0,32(sp)
    800039ca:	64e2                	ld	s1,24(sp)
    800039cc:	6942                	ld	s2,16(sp)
    800039ce:	69a2                	ld	s3,8(sp)
    800039d0:	6145                	addi	sp,sp,48
    800039d2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039d4:	0284a983          	lw	s3,40(s1)
    800039d8:	ffffd097          	auipc	ra,0xffffd
    800039dc:	47a080e7          	jalr	1146(ra) # 80000e52 <myproc>
    800039e0:	5904                	lw	s1,48(a0)
    800039e2:	413484b3          	sub	s1,s1,s3
    800039e6:	0014b493          	seqz	s1,s1
    800039ea:	bfc1                	j	800039ba <holdingsleep+0x24>

00000000800039ec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039ec:	1141                	addi	sp,sp,-16
    800039ee:	e406                	sd	ra,8(sp)
    800039f0:	e022                	sd	s0,0(sp)
    800039f2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039f4:	00005597          	auipc	a1,0x5
    800039f8:	c3458593          	addi	a1,a1,-972 # 80008628 <syscalls+0x258>
    800039fc:	0001a517          	auipc	a0,0x1a
    80003a00:	04c50513          	addi	a0,a0,76 # 8001da48 <ftable>
    80003a04:	00002097          	auipc	ra,0x2
    80003a08:	7ec080e7          	jalr	2028(ra) # 800061f0 <initlock>
}
    80003a0c:	60a2                	ld	ra,8(sp)
    80003a0e:	6402                	ld	s0,0(sp)
    80003a10:	0141                	addi	sp,sp,16
    80003a12:	8082                	ret

0000000080003a14 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a14:	1101                	addi	sp,sp,-32
    80003a16:	ec06                	sd	ra,24(sp)
    80003a18:	e822                	sd	s0,16(sp)
    80003a1a:	e426                	sd	s1,8(sp)
    80003a1c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a1e:	0001a517          	auipc	a0,0x1a
    80003a22:	02a50513          	addi	a0,a0,42 # 8001da48 <ftable>
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	85a080e7          	jalr	-1958(ra) # 80006280 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a2e:	0001a497          	auipc	s1,0x1a
    80003a32:	03248493          	addi	s1,s1,50 # 8001da60 <ftable+0x18>
    80003a36:	0001b717          	auipc	a4,0x1b
    80003a3a:	fca70713          	addi	a4,a4,-54 # 8001ea00 <disk>
    if(f->ref == 0){
    80003a3e:	40dc                	lw	a5,4(s1)
    80003a40:	cf99                	beqz	a5,80003a5e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a42:	02848493          	addi	s1,s1,40
    80003a46:	fee49ce3          	bne	s1,a4,80003a3e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a4a:	0001a517          	auipc	a0,0x1a
    80003a4e:	ffe50513          	addi	a0,a0,-2 # 8001da48 <ftable>
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	8e2080e7          	jalr	-1822(ra) # 80006334 <release>
  return 0;
    80003a5a:	4481                	li	s1,0
    80003a5c:	a819                	j	80003a72 <filealloc+0x5e>
      f->ref = 1;
    80003a5e:	4785                	li	a5,1
    80003a60:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a62:	0001a517          	auipc	a0,0x1a
    80003a66:	fe650513          	addi	a0,a0,-26 # 8001da48 <ftable>
    80003a6a:	00003097          	auipc	ra,0x3
    80003a6e:	8ca080e7          	jalr	-1846(ra) # 80006334 <release>
}
    80003a72:	8526                	mv	a0,s1
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6105                	addi	sp,sp,32
    80003a7c:	8082                	ret

0000000080003a7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a7e:	1101                	addi	sp,sp,-32
    80003a80:	ec06                	sd	ra,24(sp)
    80003a82:	e822                	sd	s0,16(sp)
    80003a84:	e426                	sd	s1,8(sp)
    80003a86:	1000                	addi	s0,sp,32
    80003a88:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a8a:	0001a517          	auipc	a0,0x1a
    80003a8e:	fbe50513          	addi	a0,a0,-66 # 8001da48 <ftable>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	7ee080e7          	jalr	2030(ra) # 80006280 <acquire>
  if(f->ref < 1)
    80003a9a:	40dc                	lw	a5,4(s1)
    80003a9c:	02f05263          	blez	a5,80003ac0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003aa0:	2785                	addiw	a5,a5,1
    80003aa2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003aa4:	0001a517          	auipc	a0,0x1a
    80003aa8:	fa450513          	addi	a0,a0,-92 # 8001da48 <ftable>
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	888080e7          	jalr	-1912(ra) # 80006334 <release>
  return f;
}
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	60e2                	ld	ra,24(sp)
    80003ab8:	6442                	ld	s0,16(sp)
    80003aba:	64a2                	ld	s1,8(sp)
    80003abc:	6105                	addi	sp,sp,32
    80003abe:	8082                	ret
    panic("filedup");
    80003ac0:	00005517          	auipc	a0,0x5
    80003ac4:	b7050513          	addi	a0,a0,-1168 # 80008630 <syscalls+0x260>
    80003ac8:	00002097          	auipc	ra,0x2
    80003acc:	234080e7          	jalr	564(ra) # 80005cfc <panic>

0000000080003ad0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ad0:	7139                	addi	sp,sp,-64
    80003ad2:	fc06                	sd	ra,56(sp)
    80003ad4:	f822                	sd	s0,48(sp)
    80003ad6:	f426                	sd	s1,40(sp)
    80003ad8:	f04a                	sd	s2,32(sp)
    80003ada:	ec4e                	sd	s3,24(sp)
    80003adc:	e852                	sd	s4,16(sp)
    80003ade:	e456                	sd	s5,8(sp)
    80003ae0:	0080                	addi	s0,sp,64
    80003ae2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ae4:	0001a517          	auipc	a0,0x1a
    80003ae8:	f6450513          	addi	a0,a0,-156 # 8001da48 <ftable>
    80003aec:	00002097          	auipc	ra,0x2
    80003af0:	794080e7          	jalr	1940(ra) # 80006280 <acquire>
  if(f->ref < 1)
    80003af4:	40dc                	lw	a5,4(s1)
    80003af6:	06f05163          	blez	a5,80003b58 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003afa:	37fd                	addiw	a5,a5,-1
    80003afc:	0007871b          	sext.w	a4,a5
    80003b00:	c0dc                	sw	a5,4(s1)
    80003b02:	06e04363          	bgtz	a4,80003b68 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b06:	0004a903          	lw	s2,0(s1)
    80003b0a:	0094ca83          	lbu	s5,9(s1)
    80003b0e:	0104ba03          	ld	s4,16(s1)
    80003b12:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b16:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b1a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b1e:	0001a517          	auipc	a0,0x1a
    80003b22:	f2a50513          	addi	a0,a0,-214 # 8001da48 <ftable>
    80003b26:	00003097          	auipc	ra,0x3
    80003b2a:	80e080e7          	jalr	-2034(ra) # 80006334 <release>

  if(ff.type == FD_PIPE){
    80003b2e:	4785                	li	a5,1
    80003b30:	04f90d63          	beq	s2,a5,80003b8a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b34:	3979                	addiw	s2,s2,-2
    80003b36:	4785                	li	a5,1
    80003b38:	0527e063          	bltu	a5,s2,80003b78 <fileclose+0xa8>
    begin_op();
    80003b3c:	00000097          	auipc	ra,0x0
    80003b40:	acc080e7          	jalr	-1332(ra) # 80003608 <begin_op>
    iput(ff.ip);
    80003b44:	854e                	mv	a0,s3
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	2b0080e7          	jalr	688(ra) # 80002df6 <iput>
    end_op();
    80003b4e:	00000097          	auipc	ra,0x0
    80003b52:	b38080e7          	jalr	-1224(ra) # 80003686 <end_op>
    80003b56:	a00d                	j	80003b78 <fileclose+0xa8>
    panic("fileclose");
    80003b58:	00005517          	auipc	a0,0x5
    80003b5c:	ae050513          	addi	a0,a0,-1312 # 80008638 <syscalls+0x268>
    80003b60:	00002097          	auipc	ra,0x2
    80003b64:	19c080e7          	jalr	412(ra) # 80005cfc <panic>
    release(&ftable.lock);
    80003b68:	0001a517          	auipc	a0,0x1a
    80003b6c:	ee050513          	addi	a0,a0,-288 # 8001da48 <ftable>
    80003b70:	00002097          	auipc	ra,0x2
    80003b74:	7c4080e7          	jalr	1988(ra) # 80006334 <release>
  }
}
    80003b78:	70e2                	ld	ra,56(sp)
    80003b7a:	7442                	ld	s0,48(sp)
    80003b7c:	74a2                	ld	s1,40(sp)
    80003b7e:	7902                	ld	s2,32(sp)
    80003b80:	69e2                	ld	s3,24(sp)
    80003b82:	6a42                	ld	s4,16(sp)
    80003b84:	6aa2                	ld	s5,8(sp)
    80003b86:	6121                	addi	sp,sp,64
    80003b88:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b8a:	85d6                	mv	a1,s5
    80003b8c:	8552                	mv	a0,s4
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	34c080e7          	jalr	844(ra) # 80003eda <pipeclose>
    80003b96:	b7cd                	j	80003b78 <fileclose+0xa8>

0000000080003b98 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b98:	715d                	addi	sp,sp,-80
    80003b9a:	e486                	sd	ra,72(sp)
    80003b9c:	e0a2                	sd	s0,64(sp)
    80003b9e:	fc26                	sd	s1,56(sp)
    80003ba0:	f84a                	sd	s2,48(sp)
    80003ba2:	f44e                	sd	s3,40(sp)
    80003ba4:	0880                	addi	s0,sp,80
    80003ba6:	84aa                	mv	s1,a0
    80003ba8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003baa:	ffffd097          	auipc	ra,0xffffd
    80003bae:	2a8080e7          	jalr	680(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bb2:	409c                	lw	a5,0(s1)
    80003bb4:	37f9                	addiw	a5,a5,-2
    80003bb6:	4705                	li	a4,1
    80003bb8:	04f76763          	bltu	a4,a5,80003c06 <filestat+0x6e>
    80003bbc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bbe:	6c88                	ld	a0,24(s1)
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	07c080e7          	jalr	124(ra) # 80002c3c <ilock>
    stati(f->ip, &st);
    80003bc8:	fb840593          	addi	a1,s0,-72
    80003bcc:	6c88                	ld	a0,24(s1)
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	2f8080e7          	jalr	760(ra) # 80002ec6 <stati>
    iunlock(f->ip);
    80003bd6:	6c88                	ld	a0,24(s1)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	126080e7          	jalr	294(ra) # 80002cfe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003be0:	46e1                	li	a3,24
    80003be2:	fb840613          	addi	a2,s0,-72
    80003be6:	85ce                	mv	a1,s3
    80003be8:	18893503          	ld	a0,392(s2)
    80003bec:	ffffd097          	auipc	ra,0xffffd
    80003bf0:	f28080e7          	jalr	-216(ra) # 80000b14 <copyout>
    80003bf4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bf8:	60a6                	ld	ra,72(sp)
    80003bfa:	6406                	ld	s0,64(sp)
    80003bfc:	74e2                	ld	s1,56(sp)
    80003bfe:	7942                	ld	s2,48(sp)
    80003c00:	79a2                	ld	s3,40(sp)
    80003c02:	6161                	addi	sp,sp,80
    80003c04:	8082                	ret
  return -1;
    80003c06:	557d                	li	a0,-1
    80003c08:	bfc5                	j	80003bf8 <filestat+0x60>

0000000080003c0a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c0a:	7179                	addi	sp,sp,-48
    80003c0c:	f406                	sd	ra,40(sp)
    80003c0e:	f022                	sd	s0,32(sp)
    80003c10:	ec26                	sd	s1,24(sp)
    80003c12:	e84a                	sd	s2,16(sp)
    80003c14:	e44e                	sd	s3,8(sp)
    80003c16:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c18:	00854783          	lbu	a5,8(a0)
    80003c1c:	c3d5                	beqz	a5,80003cc0 <fileread+0xb6>
    80003c1e:	84aa                	mv	s1,a0
    80003c20:	89ae                	mv	s3,a1
    80003c22:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c24:	411c                	lw	a5,0(a0)
    80003c26:	4705                	li	a4,1
    80003c28:	04e78963          	beq	a5,a4,80003c7a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c2c:	470d                	li	a4,3
    80003c2e:	04e78d63          	beq	a5,a4,80003c88 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c32:	4709                	li	a4,2
    80003c34:	06e79e63          	bne	a5,a4,80003cb0 <fileread+0xa6>
    ilock(f->ip);
    80003c38:	6d08                	ld	a0,24(a0)
    80003c3a:	fffff097          	auipc	ra,0xfffff
    80003c3e:	002080e7          	jalr	2(ra) # 80002c3c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c42:	874a                	mv	a4,s2
    80003c44:	5094                	lw	a3,32(s1)
    80003c46:	864e                	mv	a2,s3
    80003c48:	4585                	li	a1,1
    80003c4a:	6c88                	ld	a0,24(s1)
    80003c4c:	fffff097          	auipc	ra,0xfffff
    80003c50:	2a4080e7          	jalr	676(ra) # 80002ef0 <readi>
    80003c54:	892a                	mv	s2,a0
    80003c56:	00a05563          	blez	a0,80003c60 <fileread+0x56>
      f->off += r;
    80003c5a:	509c                	lw	a5,32(s1)
    80003c5c:	9fa9                	addw	a5,a5,a0
    80003c5e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c60:	6c88                	ld	a0,24(s1)
    80003c62:	fffff097          	auipc	ra,0xfffff
    80003c66:	09c080e7          	jalr	156(ra) # 80002cfe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c6a:	854a                	mv	a0,s2
    80003c6c:	70a2                	ld	ra,40(sp)
    80003c6e:	7402                	ld	s0,32(sp)
    80003c70:	64e2                	ld	s1,24(sp)
    80003c72:	6942                	ld	s2,16(sp)
    80003c74:	69a2                	ld	s3,8(sp)
    80003c76:	6145                	addi	sp,sp,48
    80003c78:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c7a:	6908                	ld	a0,16(a0)
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	3c6080e7          	jalr	966(ra) # 80004042 <piperead>
    80003c84:	892a                	mv	s2,a0
    80003c86:	b7d5                	j	80003c6a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c88:	02451783          	lh	a5,36(a0)
    80003c8c:	03079693          	slli	a3,a5,0x30
    80003c90:	92c1                	srli	a3,a3,0x30
    80003c92:	4725                	li	a4,9
    80003c94:	02d76863          	bltu	a4,a3,80003cc4 <fileread+0xba>
    80003c98:	0792                	slli	a5,a5,0x4
    80003c9a:	0001a717          	auipc	a4,0x1a
    80003c9e:	d0e70713          	addi	a4,a4,-754 # 8001d9a8 <devsw>
    80003ca2:	97ba                	add	a5,a5,a4
    80003ca4:	639c                	ld	a5,0(a5)
    80003ca6:	c38d                	beqz	a5,80003cc8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ca8:	4505                	li	a0,1
    80003caa:	9782                	jalr	a5
    80003cac:	892a                	mv	s2,a0
    80003cae:	bf75                	j	80003c6a <fileread+0x60>
    panic("fileread");
    80003cb0:	00005517          	auipc	a0,0x5
    80003cb4:	99850513          	addi	a0,a0,-1640 # 80008648 <syscalls+0x278>
    80003cb8:	00002097          	auipc	ra,0x2
    80003cbc:	044080e7          	jalr	68(ra) # 80005cfc <panic>
    return -1;
    80003cc0:	597d                	li	s2,-1
    80003cc2:	b765                	j	80003c6a <fileread+0x60>
      return -1;
    80003cc4:	597d                	li	s2,-1
    80003cc6:	b755                	j	80003c6a <fileread+0x60>
    80003cc8:	597d                	li	s2,-1
    80003cca:	b745                	j	80003c6a <fileread+0x60>

0000000080003ccc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003ccc:	715d                	addi	sp,sp,-80
    80003cce:	e486                	sd	ra,72(sp)
    80003cd0:	e0a2                	sd	s0,64(sp)
    80003cd2:	fc26                	sd	s1,56(sp)
    80003cd4:	f84a                	sd	s2,48(sp)
    80003cd6:	f44e                	sd	s3,40(sp)
    80003cd8:	f052                	sd	s4,32(sp)
    80003cda:	ec56                	sd	s5,24(sp)
    80003cdc:	e85a                	sd	s6,16(sp)
    80003cde:	e45e                	sd	s7,8(sp)
    80003ce0:	e062                	sd	s8,0(sp)
    80003ce2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ce4:	00954783          	lbu	a5,9(a0)
    80003ce8:	10078663          	beqz	a5,80003df4 <filewrite+0x128>
    80003cec:	892a                	mv	s2,a0
    80003cee:	8b2e                	mv	s6,a1
    80003cf0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cf2:	411c                	lw	a5,0(a0)
    80003cf4:	4705                	li	a4,1
    80003cf6:	02e78263          	beq	a5,a4,80003d1a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cfa:	470d                	li	a4,3
    80003cfc:	02e78663          	beq	a5,a4,80003d28 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d00:	4709                	li	a4,2
    80003d02:	0ee79163          	bne	a5,a4,80003de4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d06:	0ac05d63          	blez	a2,80003dc0 <filewrite+0xf4>
    int i = 0;
    80003d0a:	4981                	li	s3,0
    80003d0c:	6b85                	lui	s7,0x1
    80003d0e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d12:	6c05                	lui	s8,0x1
    80003d14:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d18:	a861                	j	80003db0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d1a:	6908                	ld	a0,16(a0)
    80003d1c:	00000097          	auipc	ra,0x0
    80003d20:	22e080e7          	jalr	558(ra) # 80003f4a <pipewrite>
    80003d24:	8a2a                	mv	s4,a0
    80003d26:	a045                	j	80003dc6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d28:	02451783          	lh	a5,36(a0)
    80003d2c:	03079693          	slli	a3,a5,0x30
    80003d30:	92c1                	srli	a3,a3,0x30
    80003d32:	4725                	li	a4,9
    80003d34:	0cd76263          	bltu	a4,a3,80003df8 <filewrite+0x12c>
    80003d38:	0792                	slli	a5,a5,0x4
    80003d3a:	0001a717          	auipc	a4,0x1a
    80003d3e:	c6e70713          	addi	a4,a4,-914 # 8001d9a8 <devsw>
    80003d42:	97ba                	add	a5,a5,a4
    80003d44:	679c                	ld	a5,8(a5)
    80003d46:	cbdd                	beqz	a5,80003dfc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d48:	4505                	li	a0,1
    80003d4a:	9782                	jalr	a5
    80003d4c:	8a2a                	mv	s4,a0
    80003d4e:	a8a5                	j	80003dc6 <filewrite+0xfa>
    80003d50:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	8b4080e7          	jalr	-1868(ra) # 80003608 <begin_op>
      ilock(f->ip);
    80003d5c:	01893503          	ld	a0,24(s2)
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	edc080e7          	jalr	-292(ra) # 80002c3c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d68:	8756                	mv	a4,s5
    80003d6a:	02092683          	lw	a3,32(s2)
    80003d6e:	01698633          	add	a2,s3,s6
    80003d72:	4585                	li	a1,1
    80003d74:	01893503          	ld	a0,24(s2)
    80003d78:	fffff097          	auipc	ra,0xfffff
    80003d7c:	270080e7          	jalr	624(ra) # 80002fe8 <writei>
    80003d80:	84aa                	mv	s1,a0
    80003d82:	00a05763          	blez	a0,80003d90 <filewrite+0xc4>
        f->off += r;
    80003d86:	02092783          	lw	a5,32(s2)
    80003d8a:	9fa9                	addw	a5,a5,a0
    80003d8c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d90:	01893503          	ld	a0,24(s2)
    80003d94:	fffff097          	auipc	ra,0xfffff
    80003d98:	f6a080e7          	jalr	-150(ra) # 80002cfe <iunlock>
      end_op();
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	8ea080e7          	jalr	-1814(ra) # 80003686 <end_op>

      if(r != n1){
    80003da4:	009a9f63          	bne	s5,s1,80003dc2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003da8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dac:	0149db63          	bge	s3,s4,80003dc2 <filewrite+0xf6>
      int n1 = n - i;
    80003db0:	413a04bb          	subw	s1,s4,s3
    80003db4:	0004879b          	sext.w	a5,s1
    80003db8:	f8fbdce3          	bge	s7,a5,80003d50 <filewrite+0x84>
    80003dbc:	84e2                	mv	s1,s8
    80003dbe:	bf49                	j	80003d50 <filewrite+0x84>
    int i = 0;
    80003dc0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dc2:	013a1f63          	bne	s4,s3,80003de0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dc6:	8552                	mv	a0,s4
    80003dc8:	60a6                	ld	ra,72(sp)
    80003dca:	6406                	ld	s0,64(sp)
    80003dcc:	74e2                	ld	s1,56(sp)
    80003dce:	7942                	ld	s2,48(sp)
    80003dd0:	79a2                	ld	s3,40(sp)
    80003dd2:	7a02                	ld	s4,32(sp)
    80003dd4:	6ae2                	ld	s5,24(sp)
    80003dd6:	6b42                	ld	s6,16(sp)
    80003dd8:	6ba2                	ld	s7,8(sp)
    80003dda:	6c02                	ld	s8,0(sp)
    80003ddc:	6161                	addi	sp,sp,80
    80003dde:	8082                	ret
    ret = (i == n ? n : -1);
    80003de0:	5a7d                	li	s4,-1
    80003de2:	b7d5                	j	80003dc6 <filewrite+0xfa>
    panic("filewrite");
    80003de4:	00005517          	auipc	a0,0x5
    80003de8:	87450513          	addi	a0,a0,-1932 # 80008658 <syscalls+0x288>
    80003dec:	00002097          	auipc	ra,0x2
    80003df0:	f10080e7          	jalr	-240(ra) # 80005cfc <panic>
    return -1;
    80003df4:	5a7d                	li	s4,-1
    80003df6:	bfc1                	j	80003dc6 <filewrite+0xfa>
      return -1;
    80003df8:	5a7d                	li	s4,-1
    80003dfa:	b7f1                	j	80003dc6 <filewrite+0xfa>
    80003dfc:	5a7d                	li	s4,-1
    80003dfe:	b7e1                	j	80003dc6 <filewrite+0xfa>

0000000080003e00 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e00:	7179                	addi	sp,sp,-48
    80003e02:	f406                	sd	ra,40(sp)
    80003e04:	f022                	sd	s0,32(sp)
    80003e06:	ec26                	sd	s1,24(sp)
    80003e08:	e84a                	sd	s2,16(sp)
    80003e0a:	e44e                	sd	s3,8(sp)
    80003e0c:	e052                	sd	s4,0(sp)
    80003e0e:	1800                	addi	s0,sp,48
    80003e10:	84aa                	mv	s1,a0
    80003e12:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e14:	0005b023          	sd	zero,0(a1)
    80003e18:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	bf8080e7          	jalr	-1032(ra) # 80003a14 <filealloc>
    80003e24:	e088                	sd	a0,0(s1)
    80003e26:	c551                	beqz	a0,80003eb2 <pipealloc+0xb2>
    80003e28:	00000097          	auipc	ra,0x0
    80003e2c:	bec080e7          	jalr	-1044(ra) # 80003a14 <filealloc>
    80003e30:	00aa3023          	sd	a0,0(s4)
    80003e34:	c92d                	beqz	a0,80003ea6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e36:	ffffc097          	auipc	ra,0xffffc
    80003e3a:	2e4080e7          	jalr	740(ra) # 8000011a <kalloc>
    80003e3e:	892a                	mv	s2,a0
    80003e40:	c125                	beqz	a0,80003ea0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e42:	4985                	li	s3,1
    80003e44:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e48:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e4c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e50:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e54:	00005597          	auipc	a1,0x5
    80003e58:	81458593          	addi	a1,a1,-2028 # 80008668 <syscalls+0x298>
    80003e5c:	00002097          	auipc	ra,0x2
    80003e60:	394080e7          	jalr	916(ra) # 800061f0 <initlock>
  (*f0)->type = FD_PIPE;
    80003e64:	609c                	ld	a5,0(s1)
    80003e66:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e6a:	609c                	ld	a5,0(s1)
    80003e6c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e70:	609c                	ld	a5,0(s1)
    80003e72:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e76:	609c                	ld	a5,0(s1)
    80003e78:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e7c:	000a3783          	ld	a5,0(s4)
    80003e80:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e84:	000a3783          	ld	a5,0(s4)
    80003e88:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e8c:	000a3783          	ld	a5,0(s4)
    80003e90:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e94:	000a3783          	ld	a5,0(s4)
    80003e98:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e9c:	4501                	li	a0,0
    80003e9e:	a025                	j	80003ec6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ea0:	6088                	ld	a0,0(s1)
    80003ea2:	e501                	bnez	a0,80003eaa <pipealloc+0xaa>
    80003ea4:	a039                	j	80003eb2 <pipealloc+0xb2>
    80003ea6:	6088                	ld	a0,0(s1)
    80003ea8:	c51d                	beqz	a0,80003ed6 <pipealloc+0xd6>
    fileclose(*f0);
    80003eaa:	00000097          	auipc	ra,0x0
    80003eae:	c26080e7          	jalr	-986(ra) # 80003ad0 <fileclose>
  if(*f1)
    80003eb2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eb6:	557d                	li	a0,-1
  if(*f1)
    80003eb8:	c799                	beqz	a5,80003ec6 <pipealloc+0xc6>
    fileclose(*f1);
    80003eba:	853e                	mv	a0,a5
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	c14080e7          	jalr	-1004(ra) # 80003ad0 <fileclose>
  return -1;
    80003ec4:	557d                	li	a0,-1
}
    80003ec6:	70a2                	ld	ra,40(sp)
    80003ec8:	7402                	ld	s0,32(sp)
    80003eca:	64e2                	ld	s1,24(sp)
    80003ecc:	6942                	ld	s2,16(sp)
    80003ece:	69a2                	ld	s3,8(sp)
    80003ed0:	6a02                	ld	s4,0(sp)
    80003ed2:	6145                	addi	sp,sp,48
    80003ed4:	8082                	ret
  return -1;
    80003ed6:	557d                	li	a0,-1
    80003ed8:	b7fd                	j	80003ec6 <pipealloc+0xc6>

0000000080003eda <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003eda:	1101                	addi	sp,sp,-32
    80003edc:	ec06                	sd	ra,24(sp)
    80003ede:	e822                	sd	s0,16(sp)
    80003ee0:	e426                	sd	s1,8(sp)
    80003ee2:	e04a                	sd	s2,0(sp)
    80003ee4:	1000                	addi	s0,sp,32
    80003ee6:	84aa                	mv	s1,a0
    80003ee8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eea:	00002097          	auipc	ra,0x2
    80003eee:	396080e7          	jalr	918(ra) # 80006280 <acquire>
  if(writable){
    80003ef2:	02090d63          	beqz	s2,80003f2c <pipeclose+0x52>
    pi->writeopen = 0;
    80003ef6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003efa:	21848513          	addi	a0,s1,536
    80003efe:	ffffd097          	auipc	ra,0xffffd
    80003f02:	694080e7          	jalr	1684(ra) # 80001592 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f06:	2204b783          	ld	a5,544(s1)
    80003f0a:	eb95                	bnez	a5,80003f3e <pipeclose+0x64>
    release(&pi->lock);
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	426080e7          	jalr	1062(ra) # 80006334 <release>
    kfree((char*)pi);
    80003f16:	8526                	mv	a0,s1
    80003f18:	ffffc097          	auipc	ra,0xffffc
    80003f1c:	104080e7          	jalr	260(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f20:	60e2                	ld	ra,24(sp)
    80003f22:	6442                	ld	s0,16(sp)
    80003f24:	64a2                	ld	s1,8(sp)
    80003f26:	6902                	ld	s2,0(sp)
    80003f28:	6105                	addi	sp,sp,32
    80003f2a:	8082                	ret
    pi->readopen = 0;
    80003f2c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f30:	21c48513          	addi	a0,s1,540
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	65e080e7          	jalr	1630(ra) # 80001592 <wakeup>
    80003f3c:	b7e9                	j	80003f06 <pipeclose+0x2c>
    release(&pi->lock);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	00002097          	auipc	ra,0x2
    80003f44:	3f4080e7          	jalr	1012(ra) # 80006334 <release>
}
    80003f48:	bfe1                	j	80003f20 <pipeclose+0x46>

0000000080003f4a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f4a:	711d                	addi	sp,sp,-96
    80003f4c:	ec86                	sd	ra,88(sp)
    80003f4e:	e8a2                	sd	s0,80(sp)
    80003f50:	e4a6                	sd	s1,72(sp)
    80003f52:	e0ca                	sd	s2,64(sp)
    80003f54:	fc4e                	sd	s3,56(sp)
    80003f56:	f852                	sd	s4,48(sp)
    80003f58:	f456                	sd	s5,40(sp)
    80003f5a:	f05a                	sd	s6,32(sp)
    80003f5c:	ec5e                	sd	s7,24(sp)
    80003f5e:	e862                	sd	s8,16(sp)
    80003f60:	1080                	addi	s0,sp,96
    80003f62:	84aa                	mv	s1,a0
    80003f64:	8aae                	mv	s5,a1
    80003f66:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	eea080e7          	jalr	-278(ra) # 80000e52 <myproc>
    80003f70:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	30c080e7          	jalr	780(ra) # 80006280 <acquire>
  while(i < n){
    80003f7c:	0b405663          	blez	s4,80004028 <pipewrite+0xde>
  int i = 0;
    80003f80:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f82:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f84:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f88:	21c48b93          	addi	s7,s1,540
    80003f8c:	a089                	j	80003fce <pipewrite+0x84>
      release(&pi->lock);
    80003f8e:	8526                	mv	a0,s1
    80003f90:	00002097          	auipc	ra,0x2
    80003f94:	3a4080e7          	jalr	932(ra) # 80006334 <release>
      return -1;
    80003f98:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f9a:	854a                	mv	a0,s2
    80003f9c:	60e6                	ld	ra,88(sp)
    80003f9e:	6446                	ld	s0,80(sp)
    80003fa0:	64a6                	ld	s1,72(sp)
    80003fa2:	6906                	ld	s2,64(sp)
    80003fa4:	79e2                	ld	s3,56(sp)
    80003fa6:	7a42                	ld	s4,48(sp)
    80003fa8:	7aa2                	ld	s5,40(sp)
    80003faa:	7b02                	ld	s6,32(sp)
    80003fac:	6be2                	ld	s7,24(sp)
    80003fae:	6c42                	ld	s8,16(sp)
    80003fb0:	6125                	addi	sp,sp,96
    80003fb2:	8082                	ret
      wakeup(&pi->nread);
    80003fb4:	8562                	mv	a0,s8
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	5dc080e7          	jalr	1500(ra) # 80001592 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fbe:	85a6                	mv	a1,s1
    80003fc0:	855e                	mv	a0,s7
    80003fc2:	ffffd097          	auipc	ra,0xffffd
    80003fc6:	56c080e7          	jalr	1388(ra) # 8000152e <sleep>
  while(i < n){
    80003fca:	07495063          	bge	s2,s4,8000402a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fce:	2204a783          	lw	a5,544(s1)
    80003fd2:	dfd5                	beqz	a5,80003f8e <pipewrite+0x44>
    80003fd4:	854e                	mv	a0,s3
    80003fd6:	ffffe097          	auipc	ra,0xffffe
    80003fda:	804080e7          	jalr	-2044(ra) # 800017da <killed>
    80003fde:	f945                	bnez	a0,80003f8e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fe0:	2184a783          	lw	a5,536(s1)
    80003fe4:	21c4a703          	lw	a4,540(s1)
    80003fe8:	2007879b          	addiw	a5,a5,512
    80003fec:	fcf704e3          	beq	a4,a5,80003fb4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ff0:	4685                	li	a3,1
    80003ff2:	01590633          	add	a2,s2,s5
    80003ff6:	faf40593          	addi	a1,s0,-81
    80003ffa:	1889b503          	ld	a0,392(s3)
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	ba2080e7          	jalr	-1118(ra) # 80000ba0 <copyin>
    80004006:	03650263          	beq	a0,s6,8000402a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000400a:	21c4a783          	lw	a5,540(s1)
    8000400e:	0017871b          	addiw	a4,a5,1
    80004012:	20e4ae23          	sw	a4,540(s1)
    80004016:	1ff7f793          	andi	a5,a5,511
    8000401a:	97a6                	add	a5,a5,s1
    8000401c:	faf44703          	lbu	a4,-81(s0)
    80004020:	00e78c23          	sb	a4,24(a5)
      i++;
    80004024:	2905                	addiw	s2,s2,1
    80004026:	b755                	j	80003fca <pipewrite+0x80>
  int i = 0;
    80004028:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000402a:	21848513          	addi	a0,s1,536
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	564080e7          	jalr	1380(ra) # 80001592 <wakeup>
  release(&pi->lock);
    80004036:	8526                	mv	a0,s1
    80004038:	00002097          	auipc	ra,0x2
    8000403c:	2fc080e7          	jalr	764(ra) # 80006334 <release>
  return i;
    80004040:	bfa9                	j	80003f9a <pipewrite+0x50>

0000000080004042 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004042:	715d                	addi	sp,sp,-80
    80004044:	e486                	sd	ra,72(sp)
    80004046:	e0a2                	sd	s0,64(sp)
    80004048:	fc26                	sd	s1,56(sp)
    8000404a:	f84a                	sd	s2,48(sp)
    8000404c:	f44e                	sd	s3,40(sp)
    8000404e:	f052                	sd	s4,32(sp)
    80004050:	ec56                	sd	s5,24(sp)
    80004052:	e85a                	sd	s6,16(sp)
    80004054:	0880                	addi	s0,sp,80
    80004056:	84aa                	mv	s1,a0
    80004058:	892e                	mv	s2,a1
    8000405a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	df6080e7          	jalr	-522(ra) # 80000e52 <myproc>
    80004064:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004066:	8526                	mv	a0,s1
    80004068:	00002097          	auipc	ra,0x2
    8000406c:	218080e7          	jalr	536(ra) # 80006280 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004070:	2184a703          	lw	a4,536(s1)
    80004074:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004078:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000407c:	02f71763          	bne	a4,a5,800040aa <piperead+0x68>
    80004080:	2244a783          	lw	a5,548(s1)
    80004084:	c39d                	beqz	a5,800040aa <piperead+0x68>
    if(killed(pr)){
    80004086:	8552                	mv	a0,s4
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	752080e7          	jalr	1874(ra) # 800017da <killed>
    80004090:	e949                	bnez	a0,80004122 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004092:	85a6                	mv	a1,s1
    80004094:	854e                	mv	a0,s3
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	498080e7          	jalr	1176(ra) # 8000152e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000409e:	2184a703          	lw	a4,536(s1)
    800040a2:	21c4a783          	lw	a5,540(s1)
    800040a6:	fcf70de3          	beq	a4,a5,80004080 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040aa:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ac:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ae:	05505463          	blez	s5,800040f6 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040b2:	2184a783          	lw	a5,536(s1)
    800040b6:	21c4a703          	lw	a4,540(s1)
    800040ba:	02f70e63          	beq	a4,a5,800040f6 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040be:	0017871b          	addiw	a4,a5,1
    800040c2:	20e4ac23          	sw	a4,536(s1)
    800040c6:	1ff7f793          	andi	a5,a5,511
    800040ca:	97a6                	add	a5,a5,s1
    800040cc:	0187c783          	lbu	a5,24(a5)
    800040d0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d4:	4685                	li	a3,1
    800040d6:	fbf40613          	addi	a2,s0,-65
    800040da:	85ca                	mv	a1,s2
    800040dc:	188a3503          	ld	a0,392(s4)
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	a34080e7          	jalr	-1484(ra) # 80000b14 <copyout>
    800040e8:	01650763          	beq	a0,s6,800040f6 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ec:	2985                	addiw	s3,s3,1
    800040ee:	0905                	addi	s2,s2,1
    800040f0:	fd3a91e3          	bne	s5,s3,800040b2 <piperead+0x70>
    800040f4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040f6:	21c48513          	addi	a0,s1,540
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	498080e7          	jalr	1176(ra) # 80001592 <wakeup>
  release(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	230080e7          	jalr	560(ra) # 80006334 <release>
  return i;
}
    8000410c:	854e                	mv	a0,s3
    8000410e:	60a6                	ld	ra,72(sp)
    80004110:	6406                	ld	s0,64(sp)
    80004112:	74e2                	ld	s1,56(sp)
    80004114:	7942                	ld	s2,48(sp)
    80004116:	79a2                	ld	s3,40(sp)
    80004118:	7a02                	ld	s4,32(sp)
    8000411a:	6ae2                	ld	s5,24(sp)
    8000411c:	6b42                	ld	s6,16(sp)
    8000411e:	6161                	addi	sp,sp,80
    80004120:	8082                	ret
      release(&pi->lock);
    80004122:	8526                	mv	a0,s1
    80004124:	00002097          	auipc	ra,0x2
    80004128:	210080e7          	jalr	528(ra) # 80006334 <release>
      return -1;
    8000412c:	59fd                	li	s3,-1
    8000412e:	bff9                	j	8000410c <piperead+0xca>

0000000080004130 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004130:	1141                	addi	sp,sp,-16
    80004132:	e422                	sd	s0,8(sp)
    80004134:	0800                	addi	s0,sp,16
    80004136:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004138:	8905                	andi	a0,a0,1
    8000413a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000413c:	8b89                	andi	a5,a5,2
    8000413e:	c399                	beqz	a5,80004144 <flags2perm+0x14>
      perm |= PTE_W;
    80004140:	00456513          	ori	a0,a0,4
    return perm;
}
    80004144:	6422                	ld	s0,8(sp)
    80004146:	0141                	addi	sp,sp,16
    80004148:	8082                	ret

000000008000414a <exec>:

int
exec(char *path, char **argv)
{
    8000414a:	de010113          	addi	sp,sp,-544
    8000414e:	20113c23          	sd	ra,536(sp)
    80004152:	20813823          	sd	s0,528(sp)
    80004156:	20913423          	sd	s1,520(sp)
    8000415a:	21213023          	sd	s2,512(sp)
    8000415e:	ffce                	sd	s3,504(sp)
    80004160:	fbd2                	sd	s4,496(sp)
    80004162:	f7d6                	sd	s5,488(sp)
    80004164:	f3da                	sd	s6,480(sp)
    80004166:	efde                	sd	s7,472(sp)
    80004168:	ebe2                	sd	s8,464(sp)
    8000416a:	e7e6                	sd	s9,456(sp)
    8000416c:	e3ea                	sd	s10,448(sp)
    8000416e:	ff6e                	sd	s11,440(sp)
    80004170:	1400                	addi	s0,sp,544
    80004172:	892a                	mv	s2,a0
    80004174:	dea43423          	sd	a0,-536(s0)
    80004178:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	cd6080e7          	jalr	-810(ra) # 80000e52 <myproc>
    80004184:	84aa                	mv	s1,a0

  begin_op();
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	482080e7          	jalr	1154(ra) # 80003608 <begin_op>

  if((ip = namei(path)) == 0){
    8000418e:	854a                	mv	a0,s2
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	258080e7          	jalr	600(ra) # 800033e8 <namei>
    80004198:	c93d                	beqz	a0,8000420e <exec+0xc4>
    8000419a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	aa0080e7          	jalr	-1376(ra) # 80002c3c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041a4:	04000713          	li	a4,64
    800041a8:	4681                	li	a3,0
    800041aa:	e5040613          	addi	a2,s0,-432
    800041ae:	4581                	li	a1,0
    800041b0:	8556                	mv	a0,s5
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	d3e080e7          	jalr	-706(ra) # 80002ef0 <readi>
    800041ba:	04000793          	li	a5,64
    800041be:	00f51a63          	bne	a0,a5,800041d2 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041c2:	e5042703          	lw	a4,-432(s0)
    800041c6:	464c47b7          	lui	a5,0x464c4
    800041ca:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ce:	04f70663          	beq	a4,a5,8000421a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041d2:	8556                	mv	a0,s5
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	cca080e7          	jalr	-822(ra) # 80002e9e <iunlockput>
    end_op();
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	4aa080e7          	jalr	1194(ra) # 80003686 <end_op>
  }
  return -1;
    800041e4:	557d                	li	a0,-1
}
    800041e6:	21813083          	ld	ra,536(sp)
    800041ea:	21013403          	ld	s0,528(sp)
    800041ee:	20813483          	ld	s1,520(sp)
    800041f2:	20013903          	ld	s2,512(sp)
    800041f6:	79fe                	ld	s3,504(sp)
    800041f8:	7a5e                	ld	s4,496(sp)
    800041fa:	7abe                	ld	s5,488(sp)
    800041fc:	7b1e                	ld	s6,480(sp)
    800041fe:	6bfe                	ld	s7,472(sp)
    80004200:	6c5e                	ld	s8,464(sp)
    80004202:	6cbe                	ld	s9,456(sp)
    80004204:	6d1e                	ld	s10,448(sp)
    80004206:	7dfa                	ld	s11,440(sp)
    80004208:	22010113          	addi	sp,sp,544
    8000420c:	8082                	ret
    end_op();
    8000420e:	fffff097          	auipc	ra,0xfffff
    80004212:	478080e7          	jalr	1144(ra) # 80003686 <end_op>
    return -1;
    80004216:	557d                	li	a0,-1
    80004218:	b7f9                	j	800041e6 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	cfa080e7          	jalr	-774(ra) # 80000f16 <proc_pagetable>
    80004224:	8b2a                	mv	s6,a0
    80004226:	d555                	beqz	a0,800041d2 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004228:	e7042783          	lw	a5,-400(s0)
    8000422c:	e8845703          	lhu	a4,-376(s0)
    80004230:	c735                	beqz	a4,8000429c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004232:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004234:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004238:	6a05                	lui	s4,0x1
    8000423a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000423e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004242:	6d85                	lui	s11,0x1
    80004244:	7d7d                	lui	s10,0xfffff
    80004246:	ac3d                	j	80004484 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004248:	00004517          	auipc	a0,0x4
    8000424c:	42850513          	addi	a0,a0,1064 # 80008670 <syscalls+0x2a0>
    80004250:	00002097          	auipc	ra,0x2
    80004254:	aac080e7          	jalr	-1364(ra) # 80005cfc <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004258:	874a                	mv	a4,s2
    8000425a:	009c86bb          	addw	a3,s9,s1
    8000425e:	4581                	li	a1,0
    80004260:	8556                	mv	a0,s5
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	c8e080e7          	jalr	-882(ra) # 80002ef0 <readi>
    8000426a:	2501                	sext.w	a0,a0
    8000426c:	1aa91963          	bne	s2,a0,8000441e <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004270:	009d84bb          	addw	s1,s11,s1
    80004274:	013d09bb          	addw	s3,s10,s3
    80004278:	1f74f663          	bgeu	s1,s7,80004464 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    8000427c:	02049593          	slli	a1,s1,0x20
    80004280:	9181                	srli	a1,a1,0x20
    80004282:	95e2                	add	a1,a1,s8
    80004284:	855a                	mv	a0,s6
    80004286:	ffffc097          	auipc	ra,0xffffc
    8000428a:	27e080e7          	jalr	638(ra) # 80000504 <walkaddr>
    8000428e:	862a                	mv	a2,a0
    if(pa == 0)
    80004290:	dd45                	beqz	a0,80004248 <exec+0xfe>
      n = PGSIZE;
    80004292:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004294:	fd49f2e3          	bgeu	s3,s4,80004258 <exec+0x10e>
      n = sz - i;
    80004298:	894e                	mv	s2,s3
    8000429a:	bf7d                	j	80004258 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000429c:	4901                	li	s2,0
  iunlockput(ip);
    8000429e:	8556                	mv	a0,s5
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	bfe080e7          	jalr	-1026(ra) # 80002e9e <iunlockput>
  end_op();
    800042a8:	fffff097          	auipc	ra,0xfffff
    800042ac:	3de080e7          	jalr	990(ra) # 80003686 <end_op>
  p = myproc();
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	ba2080e7          	jalr	-1118(ra) # 80000e52 <myproc>
    800042b8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042ba:	18053d03          	ld	s10,384(a0)
  sz = PGROUNDUP(sz);
    800042be:	6785                	lui	a5,0x1
    800042c0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800042c2:	97ca                	add	a5,a5,s2
    800042c4:	777d                	lui	a4,0xfffff
    800042c6:	8ff9                	and	a5,a5,a4
    800042c8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042cc:	4691                	li	a3,4
    800042ce:	6609                	lui	a2,0x2
    800042d0:	963e                	add	a2,a2,a5
    800042d2:	85be                	mv	a1,a5
    800042d4:	855a                	mv	a0,s6
    800042d6:	ffffc097          	auipc	ra,0xffffc
    800042da:	5e2080e7          	jalr	1506(ra) # 800008b8 <uvmalloc>
    800042de:	8c2a                	mv	s8,a0
  ip = 0;
    800042e0:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042e2:	12050e63          	beqz	a0,8000441e <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042e6:	75f9                	lui	a1,0xffffe
    800042e8:	95aa                	add	a1,a1,a0
    800042ea:	855a                	mv	a0,s6
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	7f6080e7          	jalr	2038(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    800042f4:	7afd                	lui	s5,0xfffff
    800042f6:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800042f8:	df043783          	ld	a5,-528(s0)
    800042fc:	6388                	ld	a0,0(a5)
    800042fe:	c925                	beqz	a0,8000436e <exec+0x224>
    80004300:	e9040993          	addi	s3,s0,-368
    80004304:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004308:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000430a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000430c:	ffffc097          	auipc	ra,0xffffc
    80004310:	fea080e7          	jalr	-22(ra) # 800002f6 <strlen>
    80004314:	0015079b          	addiw	a5,a0,1
    80004318:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000431c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004320:	13596663          	bltu	s2,s5,8000444c <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004324:	df043d83          	ld	s11,-528(s0)
    80004328:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000432c:	8552                	mv	a0,s4
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	fc8080e7          	jalr	-56(ra) # 800002f6 <strlen>
    80004336:	0015069b          	addiw	a3,a0,1
    8000433a:	8652                	mv	a2,s4
    8000433c:	85ca                	mv	a1,s2
    8000433e:	855a                	mv	a0,s6
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	7d4080e7          	jalr	2004(ra) # 80000b14 <copyout>
    80004348:	10054663          	bltz	a0,80004454 <exec+0x30a>
    ustack[argc] = sp;
    8000434c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004350:	0485                	addi	s1,s1,1
    80004352:	008d8793          	addi	a5,s11,8
    80004356:	def43823          	sd	a5,-528(s0)
    8000435a:	008db503          	ld	a0,8(s11)
    8000435e:	c911                	beqz	a0,80004372 <exec+0x228>
    if(argc >= MAXARG)
    80004360:	09a1                	addi	s3,s3,8
    80004362:	fb3c95e3          	bne	s9,s3,8000430c <exec+0x1c2>
  sz = sz1;
    80004366:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000436a:	4a81                	li	s5,0
    8000436c:	a84d                	j	8000441e <exec+0x2d4>
  sp = sz;
    8000436e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004370:	4481                	li	s1,0
  ustack[argc] = 0;
    80004372:	00349793          	slli	a5,s1,0x3
    80004376:	f9078793          	addi	a5,a5,-112
    8000437a:	97a2                	add	a5,a5,s0
    8000437c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004380:	00148693          	addi	a3,s1,1
    80004384:	068e                	slli	a3,a3,0x3
    80004386:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000438a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000438e:	01597663          	bgeu	s2,s5,8000439a <exec+0x250>
  sz = sz1;
    80004392:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004396:	4a81                	li	s5,0
    80004398:	a059                	j	8000441e <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000439a:	e9040613          	addi	a2,s0,-368
    8000439e:	85ca                	mv	a1,s2
    800043a0:	855a                	mv	a0,s6
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	772080e7          	jalr	1906(ra) # 80000b14 <copyout>
    800043aa:	0a054963          	bltz	a0,8000445c <exec+0x312>
  p->trapframe->a1 = sp;
    800043ae:	198bb783          	ld	a5,408(s7)
    800043b2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043b6:	de843783          	ld	a5,-536(s0)
    800043ba:	0007c703          	lbu	a4,0(a5)
    800043be:	cf11                	beqz	a4,800043da <exec+0x290>
    800043c0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043c2:	02f00693          	li	a3,47
    800043c6:	a039                	j	800043d4 <exec+0x28a>
      last = s+1;
    800043c8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800043cc:	0785                	addi	a5,a5,1
    800043ce:	fff7c703          	lbu	a4,-1(a5)
    800043d2:	c701                	beqz	a4,800043da <exec+0x290>
    if(*s == '/')
    800043d4:	fed71ce3          	bne	a4,a3,800043cc <exec+0x282>
    800043d8:	bfc5                	j	800043c8 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800043da:	4641                	li	a2,16
    800043dc:	de843583          	ld	a1,-536(s0)
    800043e0:	298b8513          	addi	a0,s7,664
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	ee0080e7          	jalr	-288(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800043ec:	188bb503          	ld	a0,392(s7)
  p->pagetable = pagetable;
    800043f0:	196bb423          	sd	s6,392(s7)
  p->sz = sz;
    800043f4:	198bb023          	sd	s8,384(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043f8:	198bb783          	ld	a5,408(s7)
    800043fc:	e6843703          	ld	a4,-408(s0)
    80004400:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004402:	198bb783          	ld	a5,408(s7)
    80004406:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000440a:	85ea                	mv	a1,s10
    8000440c:	ffffd097          	auipc	ra,0xffffd
    80004410:	ba6080e7          	jalr	-1114(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004414:	0004851b          	sext.w	a0,s1
    80004418:	b3f9                	j	800041e6 <exec+0x9c>
    8000441a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000441e:	df843583          	ld	a1,-520(s0)
    80004422:	855a                	mv	a0,s6
    80004424:	ffffd097          	auipc	ra,0xffffd
    80004428:	b8e080e7          	jalr	-1138(ra) # 80000fb2 <proc_freepagetable>
  if(ip){
    8000442c:	da0a93e3          	bnez	s5,800041d2 <exec+0x88>
  return -1;
    80004430:	557d                	li	a0,-1
    80004432:	bb55                	j	800041e6 <exec+0x9c>
    80004434:	df243c23          	sd	s2,-520(s0)
    80004438:	b7dd                	j	8000441e <exec+0x2d4>
    8000443a:	df243c23          	sd	s2,-520(s0)
    8000443e:	b7c5                	j	8000441e <exec+0x2d4>
    80004440:	df243c23          	sd	s2,-520(s0)
    80004444:	bfe9                	j	8000441e <exec+0x2d4>
    80004446:	df243c23          	sd	s2,-520(s0)
    8000444a:	bfd1                	j	8000441e <exec+0x2d4>
  sz = sz1;
    8000444c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004450:	4a81                	li	s5,0
    80004452:	b7f1                	j	8000441e <exec+0x2d4>
  sz = sz1;
    80004454:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004458:	4a81                	li	s5,0
    8000445a:	b7d1                	j	8000441e <exec+0x2d4>
  sz = sz1;
    8000445c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004460:	4a81                	li	s5,0
    80004462:	bf75                	j	8000441e <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004464:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004468:	e0843783          	ld	a5,-504(s0)
    8000446c:	0017869b          	addiw	a3,a5,1
    80004470:	e0d43423          	sd	a3,-504(s0)
    80004474:	e0043783          	ld	a5,-512(s0)
    80004478:	0387879b          	addiw	a5,a5,56
    8000447c:	e8845703          	lhu	a4,-376(s0)
    80004480:	e0e6dfe3          	bge	a3,a4,8000429e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004484:	2781                	sext.w	a5,a5
    80004486:	e0f43023          	sd	a5,-512(s0)
    8000448a:	03800713          	li	a4,56
    8000448e:	86be                	mv	a3,a5
    80004490:	e1840613          	addi	a2,s0,-488
    80004494:	4581                	li	a1,0
    80004496:	8556                	mv	a0,s5
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	a58080e7          	jalr	-1448(ra) # 80002ef0 <readi>
    800044a0:	03800793          	li	a5,56
    800044a4:	f6f51be3          	bne	a0,a5,8000441a <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800044a8:	e1842783          	lw	a5,-488(s0)
    800044ac:	4705                	li	a4,1
    800044ae:	fae79de3          	bne	a5,a4,80004468 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800044b2:	e4043483          	ld	s1,-448(s0)
    800044b6:	e3843783          	ld	a5,-456(s0)
    800044ba:	f6f4ede3          	bltu	s1,a5,80004434 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044be:	e2843783          	ld	a5,-472(s0)
    800044c2:	94be                	add	s1,s1,a5
    800044c4:	f6f4ebe3          	bltu	s1,a5,8000443a <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    800044c8:	de043703          	ld	a4,-544(s0)
    800044cc:	8ff9                	and	a5,a5,a4
    800044ce:	fbad                	bnez	a5,80004440 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044d0:	e1c42503          	lw	a0,-484(s0)
    800044d4:	00000097          	auipc	ra,0x0
    800044d8:	c5c080e7          	jalr	-932(ra) # 80004130 <flags2perm>
    800044dc:	86aa                	mv	a3,a0
    800044de:	8626                	mv	a2,s1
    800044e0:	85ca                	mv	a1,s2
    800044e2:	855a                	mv	a0,s6
    800044e4:	ffffc097          	auipc	ra,0xffffc
    800044e8:	3d4080e7          	jalr	980(ra) # 800008b8 <uvmalloc>
    800044ec:	dea43c23          	sd	a0,-520(s0)
    800044f0:	d939                	beqz	a0,80004446 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044f2:	e2843c03          	ld	s8,-472(s0)
    800044f6:	e2042c83          	lw	s9,-480(s0)
    800044fa:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044fe:	f60b83e3          	beqz	s7,80004464 <exec+0x31a>
    80004502:	89de                	mv	s3,s7
    80004504:	4481                	li	s1,0
    80004506:	bb9d                	j	8000427c <exec+0x132>

0000000080004508 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004508:	7179                	addi	sp,sp,-48
    8000450a:	f406                	sd	ra,40(sp)
    8000450c:	f022                	sd	s0,32(sp)
    8000450e:	ec26                	sd	s1,24(sp)
    80004510:	e84a                	sd	s2,16(sp)
    80004512:	1800                	addi	s0,sp,48
    80004514:	892e                	mv	s2,a1
    80004516:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004518:	fdc40593          	addi	a1,s0,-36
    8000451c:	ffffe097          	auipc	ra,0xffffe
    80004520:	b0e080e7          	jalr	-1266(ra) # 8000202a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004524:	fdc42703          	lw	a4,-36(s0)
    80004528:	47bd                	li	a5,15
    8000452a:	02e7eb63          	bltu	a5,a4,80004560 <argfd+0x58>
    8000452e:	ffffd097          	auipc	ra,0xffffd
    80004532:	924080e7          	jalr	-1756(ra) # 80000e52 <myproc>
    80004536:	fdc42703          	lw	a4,-36(s0)
    8000453a:	04270793          	addi	a5,a4,66 # fffffffffffff042 <end+0xffffffff7ffd82c2>
    8000453e:	078e                	slli	a5,a5,0x3
    80004540:	953e                	add	a0,a0,a5
    80004542:	611c                	ld	a5,0(a0)
    80004544:	c385                	beqz	a5,80004564 <argfd+0x5c>
    return -1;
  if(pfd)
    80004546:	00090463          	beqz	s2,8000454e <argfd+0x46>
    *pfd = fd;
    8000454a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000454e:	4501                	li	a0,0
  if(pf)
    80004550:	c091                	beqz	s1,80004554 <argfd+0x4c>
    *pf = f;
    80004552:	e09c                	sd	a5,0(s1)
}
    80004554:	70a2                	ld	ra,40(sp)
    80004556:	7402                	ld	s0,32(sp)
    80004558:	64e2                	ld	s1,24(sp)
    8000455a:	6942                	ld	s2,16(sp)
    8000455c:	6145                	addi	sp,sp,48
    8000455e:	8082                	ret
    return -1;
    80004560:	557d                	li	a0,-1
    80004562:	bfcd                	j	80004554 <argfd+0x4c>
    80004564:	557d                	li	a0,-1
    80004566:	b7fd                	j	80004554 <argfd+0x4c>

0000000080004568 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004568:	1101                	addi	sp,sp,-32
    8000456a:	ec06                	sd	ra,24(sp)
    8000456c:	e822                	sd	s0,16(sp)
    8000456e:	e426                	sd	s1,8(sp)
    80004570:	1000                	addi	s0,sp,32
    80004572:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004574:	ffffd097          	auipc	ra,0xffffd
    80004578:	8de080e7          	jalr	-1826(ra) # 80000e52 <myproc>
    8000457c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000457e:	21050793          	addi	a5,a0,528
    80004582:	4501                	li	a0,0
    80004584:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004586:	6398                	ld	a4,0(a5)
    80004588:	cb19                	beqz	a4,8000459e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000458a:	2505                	addiw	a0,a0,1
    8000458c:	07a1                	addi	a5,a5,8
    8000458e:	fed51ce3          	bne	a0,a3,80004586 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004592:	557d                	li	a0,-1
}
    80004594:	60e2                	ld	ra,24(sp)
    80004596:	6442                	ld	s0,16(sp)
    80004598:	64a2                	ld	s1,8(sp)
    8000459a:	6105                	addi	sp,sp,32
    8000459c:	8082                	ret
      p->ofile[fd] = f;
    8000459e:	04250793          	addi	a5,a0,66
    800045a2:	078e                	slli	a5,a5,0x3
    800045a4:	963e                	add	a2,a2,a5
    800045a6:	e204                	sd	s1,0(a2)
      return fd;
    800045a8:	b7f5                	j	80004594 <fdalloc+0x2c>

00000000800045aa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045aa:	715d                	addi	sp,sp,-80
    800045ac:	e486                	sd	ra,72(sp)
    800045ae:	e0a2                	sd	s0,64(sp)
    800045b0:	fc26                	sd	s1,56(sp)
    800045b2:	f84a                	sd	s2,48(sp)
    800045b4:	f44e                	sd	s3,40(sp)
    800045b6:	f052                	sd	s4,32(sp)
    800045b8:	ec56                	sd	s5,24(sp)
    800045ba:	e85a                	sd	s6,16(sp)
    800045bc:	0880                	addi	s0,sp,80
    800045be:	8b2e                	mv	s6,a1
    800045c0:	89b2                	mv	s3,a2
    800045c2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045c4:	fb040593          	addi	a1,s0,-80
    800045c8:	fffff097          	auipc	ra,0xfffff
    800045cc:	e3e080e7          	jalr	-450(ra) # 80003406 <nameiparent>
    800045d0:	84aa                	mv	s1,a0
    800045d2:	14050f63          	beqz	a0,80004730 <create+0x186>
    return 0;

  ilock(dp);
    800045d6:	ffffe097          	auipc	ra,0xffffe
    800045da:	666080e7          	jalr	1638(ra) # 80002c3c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045de:	4601                	li	a2,0
    800045e0:	fb040593          	addi	a1,s0,-80
    800045e4:	8526                	mv	a0,s1
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	b3a080e7          	jalr	-1222(ra) # 80003120 <dirlookup>
    800045ee:	8aaa                	mv	s5,a0
    800045f0:	c931                	beqz	a0,80004644 <create+0x9a>
    iunlockput(dp);
    800045f2:	8526                	mv	a0,s1
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	8aa080e7          	jalr	-1878(ra) # 80002e9e <iunlockput>
    ilock(ip);
    800045fc:	8556                	mv	a0,s5
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	63e080e7          	jalr	1598(ra) # 80002c3c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004606:	000b059b          	sext.w	a1,s6
    8000460a:	4789                	li	a5,2
    8000460c:	02f59563          	bne	a1,a5,80004636 <create+0x8c>
    80004610:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd82c4>
    80004614:	37f9                	addiw	a5,a5,-2
    80004616:	17c2                	slli	a5,a5,0x30
    80004618:	93c1                	srli	a5,a5,0x30
    8000461a:	4705                	li	a4,1
    8000461c:	00f76d63          	bltu	a4,a5,80004636 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004620:	8556                	mv	a0,s5
    80004622:	60a6                	ld	ra,72(sp)
    80004624:	6406                	ld	s0,64(sp)
    80004626:	74e2                	ld	s1,56(sp)
    80004628:	7942                	ld	s2,48(sp)
    8000462a:	79a2                	ld	s3,40(sp)
    8000462c:	7a02                	ld	s4,32(sp)
    8000462e:	6ae2                	ld	s5,24(sp)
    80004630:	6b42                	ld	s6,16(sp)
    80004632:	6161                	addi	sp,sp,80
    80004634:	8082                	ret
    iunlockput(ip);
    80004636:	8556                	mv	a0,s5
    80004638:	fffff097          	auipc	ra,0xfffff
    8000463c:	866080e7          	jalr	-1946(ra) # 80002e9e <iunlockput>
    return 0;
    80004640:	4a81                	li	s5,0
    80004642:	bff9                	j	80004620 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004644:	85da                	mv	a1,s6
    80004646:	4088                	lw	a0,0(s1)
    80004648:	ffffe097          	auipc	ra,0xffffe
    8000464c:	456080e7          	jalr	1110(ra) # 80002a9e <ialloc>
    80004650:	8a2a                	mv	s4,a0
    80004652:	c539                	beqz	a0,800046a0 <create+0xf6>
  ilock(ip);
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	5e8080e7          	jalr	1512(ra) # 80002c3c <ilock>
  ip->major = major;
    8000465c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004660:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004664:	4905                	li	s2,1
    80004666:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000466a:	8552                	mv	a0,s4
    8000466c:	ffffe097          	auipc	ra,0xffffe
    80004670:	504080e7          	jalr	1284(ra) # 80002b70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004674:	000b059b          	sext.w	a1,s6
    80004678:	03258b63          	beq	a1,s2,800046ae <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    8000467c:	004a2603          	lw	a2,4(s4)
    80004680:	fb040593          	addi	a1,s0,-80
    80004684:	8526                	mv	a0,s1
    80004686:	fffff097          	auipc	ra,0xfffff
    8000468a:	cb0080e7          	jalr	-848(ra) # 80003336 <dirlink>
    8000468e:	06054f63          	bltz	a0,8000470c <create+0x162>
  iunlockput(dp);
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	80a080e7          	jalr	-2038(ra) # 80002e9e <iunlockput>
  return ip;
    8000469c:	8ad2                	mv	s5,s4
    8000469e:	b749                	j	80004620 <create+0x76>
    iunlockput(dp);
    800046a0:	8526                	mv	a0,s1
    800046a2:	ffffe097          	auipc	ra,0xffffe
    800046a6:	7fc080e7          	jalr	2044(ra) # 80002e9e <iunlockput>
    return 0;
    800046aa:	8ad2                	mv	s5,s4
    800046ac:	bf95                	j	80004620 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ae:	004a2603          	lw	a2,4(s4)
    800046b2:	00004597          	auipc	a1,0x4
    800046b6:	fde58593          	addi	a1,a1,-34 # 80008690 <syscalls+0x2c0>
    800046ba:	8552                	mv	a0,s4
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	c7a080e7          	jalr	-902(ra) # 80003336 <dirlink>
    800046c4:	04054463          	bltz	a0,8000470c <create+0x162>
    800046c8:	40d0                	lw	a2,4(s1)
    800046ca:	00004597          	auipc	a1,0x4
    800046ce:	fce58593          	addi	a1,a1,-50 # 80008698 <syscalls+0x2c8>
    800046d2:	8552                	mv	a0,s4
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	c62080e7          	jalr	-926(ra) # 80003336 <dirlink>
    800046dc:	02054863          	bltz	a0,8000470c <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800046e0:	004a2603          	lw	a2,4(s4)
    800046e4:	fb040593          	addi	a1,s0,-80
    800046e8:	8526                	mv	a0,s1
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	c4c080e7          	jalr	-948(ra) # 80003336 <dirlink>
    800046f2:	00054d63          	bltz	a0,8000470c <create+0x162>
    dp->nlink++;  // for ".."
    800046f6:	04a4d783          	lhu	a5,74(s1)
    800046fa:	2785                	addiw	a5,a5,1
    800046fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004700:	8526                	mv	a0,s1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	46e080e7          	jalr	1134(ra) # 80002b70 <iupdate>
    8000470a:	b761                	j	80004692 <create+0xe8>
  ip->nlink = 0;
    8000470c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004710:	8552                	mv	a0,s4
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	45e080e7          	jalr	1118(ra) # 80002b70 <iupdate>
  iunlockput(ip);
    8000471a:	8552                	mv	a0,s4
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	782080e7          	jalr	1922(ra) # 80002e9e <iunlockput>
  iunlockput(dp);
    80004724:	8526                	mv	a0,s1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	778080e7          	jalr	1912(ra) # 80002e9e <iunlockput>
  return 0;
    8000472e:	bdcd                	j	80004620 <create+0x76>
    return 0;
    80004730:	8aaa                	mv	s5,a0
    80004732:	b5fd                	j	80004620 <create+0x76>

0000000080004734 <sys_dup>:
{
    80004734:	7179                	addi	sp,sp,-48
    80004736:	f406                	sd	ra,40(sp)
    80004738:	f022                	sd	s0,32(sp)
    8000473a:	ec26                	sd	s1,24(sp)
    8000473c:	e84a                	sd	s2,16(sp)
    8000473e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004740:	fd840613          	addi	a2,s0,-40
    80004744:	4581                	li	a1,0
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	dc0080e7          	jalr	-576(ra) # 80004508 <argfd>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004752:	02054363          	bltz	a0,80004778 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004756:	fd843903          	ld	s2,-40(s0)
    8000475a:	854a                	mv	a0,s2
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	e0c080e7          	jalr	-500(ra) # 80004568 <fdalloc>
    80004764:	84aa                	mv	s1,a0
    return -1;
    80004766:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004768:	00054863          	bltz	a0,80004778 <sys_dup+0x44>
  filedup(f);
    8000476c:	854a                	mv	a0,s2
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	310080e7          	jalr	784(ra) # 80003a7e <filedup>
  return fd;
    80004776:	87a6                	mv	a5,s1
}
    80004778:	853e                	mv	a0,a5
    8000477a:	70a2                	ld	ra,40(sp)
    8000477c:	7402                	ld	s0,32(sp)
    8000477e:	64e2                	ld	s1,24(sp)
    80004780:	6942                	ld	s2,16(sp)
    80004782:	6145                	addi	sp,sp,48
    80004784:	8082                	ret

0000000080004786 <sys_read>:
{
    80004786:	7179                	addi	sp,sp,-48
    80004788:	f406                	sd	ra,40(sp)
    8000478a:	f022                	sd	s0,32(sp)
    8000478c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000478e:	fd840593          	addi	a1,s0,-40
    80004792:	4505                	li	a0,1
    80004794:	ffffe097          	auipc	ra,0xffffe
    80004798:	8b6080e7          	jalr	-1866(ra) # 8000204a <argaddr>
  argint(2, &n);
    8000479c:	fe440593          	addi	a1,s0,-28
    800047a0:	4509                	li	a0,2
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	888080e7          	jalr	-1912(ra) # 8000202a <argint>
  if(argfd(0, 0, &f) < 0)
    800047aa:	fe840613          	addi	a2,s0,-24
    800047ae:	4581                	li	a1,0
    800047b0:	4501                	li	a0,0
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	d56080e7          	jalr	-682(ra) # 80004508 <argfd>
    800047ba:	87aa                	mv	a5,a0
    return -1;
    800047bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047be:	0007cc63          	bltz	a5,800047d6 <sys_read+0x50>
  return fileread(f, p, n);
    800047c2:	fe442603          	lw	a2,-28(s0)
    800047c6:	fd843583          	ld	a1,-40(s0)
    800047ca:	fe843503          	ld	a0,-24(s0)
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	43c080e7          	jalr	1084(ra) # 80003c0a <fileread>
}
    800047d6:	70a2                	ld	ra,40(sp)
    800047d8:	7402                	ld	s0,32(sp)
    800047da:	6145                	addi	sp,sp,48
    800047dc:	8082                	ret

00000000800047de <sys_write>:
{
    800047de:	7179                	addi	sp,sp,-48
    800047e0:	f406                	sd	ra,40(sp)
    800047e2:	f022                	sd	s0,32(sp)
    800047e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047e6:	fd840593          	addi	a1,s0,-40
    800047ea:	4505                	li	a0,1
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	85e080e7          	jalr	-1954(ra) # 8000204a <argaddr>
  argint(2, &n);
    800047f4:	fe440593          	addi	a1,s0,-28
    800047f8:	4509                	li	a0,2
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	830080e7          	jalr	-2000(ra) # 8000202a <argint>
  if(argfd(0, 0, &f) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	cfe080e7          	jalr	-770(ra) # 80004508 <argfd>
    80004812:	87aa                	mv	a5,a0
    return -1;
    80004814:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004816:	0007cc63          	bltz	a5,8000482e <sys_write+0x50>
  return filewrite(f, p, n);
    8000481a:	fe442603          	lw	a2,-28(s0)
    8000481e:	fd843583          	ld	a1,-40(s0)
    80004822:	fe843503          	ld	a0,-24(s0)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	4a6080e7          	jalr	1190(ra) # 80003ccc <filewrite>
}
    8000482e:	70a2                	ld	ra,40(sp)
    80004830:	7402                	ld	s0,32(sp)
    80004832:	6145                	addi	sp,sp,48
    80004834:	8082                	ret

0000000080004836 <sys_close>:
{
    80004836:	1101                	addi	sp,sp,-32
    80004838:	ec06                	sd	ra,24(sp)
    8000483a:	e822                	sd	s0,16(sp)
    8000483c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000483e:	fe040613          	addi	a2,s0,-32
    80004842:	fec40593          	addi	a1,s0,-20
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	cc0080e7          	jalr	-832(ra) # 80004508 <argfd>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004852:	02054563          	bltz	a0,8000487c <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80004856:	ffffc097          	auipc	ra,0xffffc
    8000485a:	5fc080e7          	jalr	1532(ra) # 80000e52 <myproc>
    8000485e:	fec42783          	lw	a5,-20(s0)
    80004862:	04278793          	addi	a5,a5,66
    80004866:	078e                	slli	a5,a5,0x3
    80004868:	953e                	add	a0,a0,a5
    8000486a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000486e:	fe043503          	ld	a0,-32(s0)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	25e080e7          	jalr	606(ra) # 80003ad0 <fileclose>
  return 0;
    8000487a:	4781                	li	a5,0
}
    8000487c:	853e                	mv	a0,a5
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	6105                	addi	sp,sp,32
    80004884:	8082                	ret

0000000080004886 <sys_fstat>:
{
    80004886:	1101                	addi	sp,sp,-32
    80004888:	ec06                	sd	ra,24(sp)
    8000488a:	e822                	sd	s0,16(sp)
    8000488c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000488e:	fe040593          	addi	a1,s0,-32
    80004892:	4505                	li	a0,1
    80004894:	ffffd097          	auipc	ra,0xffffd
    80004898:	7b6080e7          	jalr	1974(ra) # 8000204a <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000489c:	fe840613          	addi	a2,s0,-24
    800048a0:	4581                	li	a1,0
    800048a2:	4501                	li	a0,0
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	c64080e7          	jalr	-924(ra) # 80004508 <argfd>
    800048ac:	87aa                	mv	a5,a0
    return -1;
    800048ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048b0:	0007ca63          	bltz	a5,800048c4 <sys_fstat+0x3e>
  return filestat(f, st);
    800048b4:	fe043583          	ld	a1,-32(s0)
    800048b8:	fe843503          	ld	a0,-24(s0)
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	2dc080e7          	jalr	732(ra) # 80003b98 <filestat>
}
    800048c4:	60e2                	ld	ra,24(sp)
    800048c6:	6442                	ld	s0,16(sp)
    800048c8:	6105                	addi	sp,sp,32
    800048ca:	8082                	ret

00000000800048cc <sys_link>:
{
    800048cc:	7169                	addi	sp,sp,-304
    800048ce:	f606                	sd	ra,296(sp)
    800048d0:	f222                	sd	s0,288(sp)
    800048d2:	ee26                	sd	s1,280(sp)
    800048d4:	ea4a                	sd	s2,272(sp)
    800048d6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048d8:	08000613          	li	a2,128
    800048dc:	ed040593          	addi	a1,s0,-304
    800048e0:	4501                	li	a0,0
    800048e2:	ffffd097          	auipc	ra,0xffffd
    800048e6:	788080e7          	jalr	1928(ra) # 8000206a <argstr>
    return -1;
    800048ea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ec:	10054e63          	bltz	a0,80004a08 <sys_link+0x13c>
    800048f0:	08000613          	li	a2,128
    800048f4:	f5040593          	addi	a1,s0,-176
    800048f8:	4505                	li	a0,1
    800048fa:	ffffd097          	auipc	ra,0xffffd
    800048fe:	770080e7          	jalr	1904(ra) # 8000206a <argstr>
    return -1;
    80004902:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004904:	10054263          	bltz	a0,80004a08 <sys_link+0x13c>
  begin_op();
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	d00080e7          	jalr	-768(ra) # 80003608 <begin_op>
  if((ip = namei(old)) == 0){
    80004910:	ed040513          	addi	a0,s0,-304
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	ad4080e7          	jalr	-1324(ra) # 800033e8 <namei>
    8000491c:	84aa                	mv	s1,a0
    8000491e:	c551                	beqz	a0,800049aa <sys_link+0xde>
  ilock(ip);
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	31c080e7          	jalr	796(ra) # 80002c3c <ilock>
  if(ip->type == T_DIR){
    80004928:	04449703          	lh	a4,68(s1)
    8000492c:	4785                	li	a5,1
    8000492e:	08f70463          	beq	a4,a5,800049b6 <sys_link+0xea>
  ip->nlink++;
    80004932:	04a4d783          	lhu	a5,74(s1)
    80004936:	2785                	addiw	a5,a5,1
    80004938:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	232080e7          	jalr	562(ra) # 80002b70 <iupdate>
  iunlock(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	3b6080e7          	jalr	950(ra) # 80002cfe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004950:	fd040593          	addi	a1,s0,-48
    80004954:	f5040513          	addi	a0,s0,-176
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	aae080e7          	jalr	-1362(ra) # 80003406 <nameiparent>
    80004960:	892a                	mv	s2,a0
    80004962:	c935                	beqz	a0,800049d6 <sys_link+0x10a>
  ilock(dp);
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	2d8080e7          	jalr	728(ra) # 80002c3c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000496c:	00092703          	lw	a4,0(s2)
    80004970:	409c                	lw	a5,0(s1)
    80004972:	04f71d63          	bne	a4,a5,800049cc <sys_link+0x100>
    80004976:	40d0                	lw	a2,4(s1)
    80004978:	fd040593          	addi	a1,s0,-48
    8000497c:	854a                	mv	a0,s2
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	9b8080e7          	jalr	-1608(ra) # 80003336 <dirlink>
    80004986:	04054363          	bltz	a0,800049cc <sys_link+0x100>
  iunlockput(dp);
    8000498a:	854a                	mv	a0,s2
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	512080e7          	jalr	1298(ra) # 80002e9e <iunlockput>
  iput(ip);
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	460080e7          	jalr	1120(ra) # 80002df6 <iput>
  end_op();
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	ce8080e7          	jalr	-792(ra) # 80003686 <end_op>
  return 0;
    800049a6:	4781                	li	a5,0
    800049a8:	a085                	j	80004a08 <sys_link+0x13c>
    end_op();
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	cdc080e7          	jalr	-804(ra) # 80003686 <end_op>
    return -1;
    800049b2:	57fd                	li	a5,-1
    800049b4:	a891                	j	80004a08 <sys_link+0x13c>
    iunlockput(ip);
    800049b6:	8526                	mv	a0,s1
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	4e6080e7          	jalr	1254(ra) # 80002e9e <iunlockput>
    end_op();
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	cc6080e7          	jalr	-826(ra) # 80003686 <end_op>
    return -1;
    800049c8:	57fd                	li	a5,-1
    800049ca:	a83d                	j	80004a08 <sys_link+0x13c>
    iunlockput(dp);
    800049cc:	854a                	mv	a0,s2
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	4d0080e7          	jalr	1232(ra) # 80002e9e <iunlockput>
  ilock(ip);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	264080e7          	jalr	612(ra) # 80002c3c <ilock>
  ip->nlink--;
    800049e0:	04a4d783          	lhu	a5,74(s1)
    800049e4:	37fd                	addiw	a5,a5,-1
    800049e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	184080e7          	jalr	388(ra) # 80002b70 <iupdate>
  iunlockput(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	4a8080e7          	jalr	1192(ra) # 80002e9e <iunlockput>
  end_op();
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	c88080e7          	jalr	-888(ra) # 80003686 <end_op>
  return -1;
    80004a06:	57fd                	li	a5,-1
}
    80004a08:	853e                	mv	a0,a5
    80004a0a:	70b2                	ld	ra,296(sp)
    80004a0c:	7412                	ld	s0,288(sp)
    80004a0e:	64f2                	ld	s1,280(sp)
    80004a10:	6952                	ld	s2,272(sp)
    80004a12:	6155                	addi	sp,sp,304
    80004a14:	8082                	ret

0000000080004a16 <sys_unlink>:
{
    80004a16:	7151                	addi	sp,sp,-240
    80004a18:	f586                	sd	ra,232(sp)
    80004a1a:	f1a2                	sd	s0,224(sp)
    80004a1c:	eda6                	sd	s1,216(sp)
    80004a1e:	e9ca                	sd	s2,208(sp)
    80004a20:	e5ce                	sd	s3,200(sp)
    80004a22:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a24:	08000613          	li	a2,128
    80004a28:	f3040593          	addi	a1,s0,-208
    80004a2c:	4501                	li	a0,0
    80004a2e:	ffffd097          	auipc	ra,0xffffd
    80004a32:	63c080e7          	jalr	1596(ra) # 8000206a <argstr>
    80004a36:	18054163          	bltz	a0,80004bb8 <sys_unlink+0x1a2>
  begin_op();
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	bce080e7          	jalr	-1074(ra) # 80003608 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a42:	fb040593          	addi	a1,s0,-80
    80004a46:	f3040513          	addi	a0,s0,-208
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	9bc080e7          	jalr	-1604(ra) # 80003406 <nameiparent>
    80004a52:	84aa                	mv	s1,a0
    80004a54:	c979                	beqz	a0,80004b2a <sys_unlink+0x114>
  ilock(dp);
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	1e6080e7          	jalr	486(ra) # 80002c3c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a5e:	00004597          	auipc	a1,0x4
    80004a62:	c3258593          	addi	a1,a1,-974 # 80008690 <syscalls+0x2c0>
    80004a66:	fb040513          	addi	a0,s0,-80
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	69c080e7          	jalr	1692(ra) # 80003106 <namecmp>
    80004a72:	14050a63          	beqz	a0,80004bc6 <sys_unlink+0x1b0>
    80004a76:	00004597          	auipc	a1,0x4
    80004a7a:	c2258593          	addi	a1,a1,-990 # 80008698 <syscalls+0x2c8>
    80004a7e:	fb040513          	addi	a0,s0,-80
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	684080e7          	jalr	1668(ra) # 80003106 <namecmp>
    80004a8a:	12050e63          	beqz	a0,80004bc6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a8e:	f2c40613          	addi	a2,s0,-212
    80004a92:	fb040593          	addi	a1,s0,-80
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	688080e7          	jalr	1672(ra) # 80003120 <dirlookup>
    80004aa0:	892a                	mv	s2,a0
    80004aa2:	12050263          	beqz	a0,80004bc6 <sys_unlink+0x1b0>
  ilock(ip);
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	196080e7          	jalr	406(ra) # 80002c3c <ilock>
  if(ip->nlink < 1)
    80004aae:	04a91783          	lh	a5,74(s2)
    80004ab2:	08f05263          	blez	a5,80004b36 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ab6:	04491703          	lh	a4,68(s2)
    80004aba:	4785                	li	a5,1
    80004abc:	08f70563          	beq	a4,a5,80004b46 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ac0:	4641                	li	a2,16
    80004ac2:	4581                	li	a1,0
    80004ac4:	fc040513          	addi	a0,s0,-64
    80004ac8:	ffffb097          	auipc	ra,0xffffb
    80004acc:	6b2080e7          	jalr	1714(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad0:	4741                	li	a4,16
    80004ad2:	f2c42683          	lw	a3,-212(s0)
    80004ad6:	fc040613          	addi	a2,s0,-64
    80004ada:	4581                	li	a1,0
    80004adc:	8526                	mv	a0,s1
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	50a080e7          	jalr	1290(ra) # 80002fe8 <writei>
    80004ae6:	47c1                	li	a5,16
    80004ae8:	0af51563          	bne	a0,a5,80004b92 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004aec:	04491703          	lh	a4,68(s2)
    80004af0:	4785                	li	a5,1
    80004af2:	0af70863          	beq	a4,a5,80004ba2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	3a6080e7          	jalr	934(ra) # 80002e9e <iunlockput>
  ip->nlink--;
    80004b00:	04a95783          	lhu	a5,74(s2)
    80004b04:	37fd                	addiw	a5,a5,-1
    80004b06:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b0a:	854a                	mv	a0,s2
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	064080e7          	jalr	100(ra) # 80002b70 <iupdate>
  iunlockput(ip);
    80004b14:	854a                	mv	a0,s2
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	388080e7          	jalr	904(ra) # 80002e9e <iunlockput>
  end_op();
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	b68080e7          	jalr	-1176(ra) # 80003686 <end_op>
  return 0;
    80004b26:	4501                	li	a0,0
    80004b28:	a84d                	j	80004bda <sys_unlink+0x1c4>
    end_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	b5c080e7          	jalr	-1188(ra) # 80003686 <end_op>
    return -1;
    80004b32:	557d                	li	a0,-1
    80004b34:	a05d                	j	80004bda <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b36:	00004517          	auipc	a0,0x4
    80004b3a:	b6a50513          	addi	a0,a0,-1174 # 800086a0 <syscalls+0x2d0>
    80004b3e:	00001097          	auipc	ra,0x1
    80004b42:	1be080e7          	jalr	446(ra) # 80005cfc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b46:	04c92703          	lw	a4,76(s2)
    80004b4a:	02000793          	li	a5,32
    80004b4e:	f6e7f9e3          	bgeu	a5,a4,80004ac0 <sys_unlink+0xaa>
    80004b52:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b56:	4741                	li	a4,16
    80004b58:	86ce                	mv	a3,s3
    80004b5a:	f1840613          	addi	a2,s0,-232
    80004b5e:	4581                	li	a1,0
    80004b60:	854a                	mv	a0,s2
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	38e080e7          	jalr	910(ra) # 80002ef0 <readi>
    80004b6a:	47c1                	li	a5,16
    80004b6c:	00f51b63          	bne	a0,a5,80004b82 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b70:	f1845783          	lhu	a5,-232(s0)
    80004b74:	e7a1                	bnez	a5,80004bbc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b76:	29c1                	addiw	s3,s3,16
    80004b78:	04c92783          	lw	a5,76(s2)
    80004b7c:	fcf9ede3          	bltu	s3,a5,80004b56 <sys_unlink+0x140>
    80004b80:	b781                	j	80004ac0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b82:	00004517          	auipc	a0,0x4
    80004b86:	b3650513          	addi	a0,a0,-1226 # 800086b8 <syscalls+0x2e8>
    80004b8a:	00001097          	auipc	ra,0x1
    80004b8e:	172080e7          	jalr	370(ra) # 80005cfc <panic>
    panic("unlink: writei");
    80004b92:	00004517          	auipc	a0,0x4
    80004b96:	b3e50513          	addi	a0,a0,-1218 # 800086d0 <syscalls+0x300>
    80004b9a:	00001097          	auipc	ra,0x1
    80004b9e:	162080e7          	jalr	354(ra) # 80005cfc <panic>
    dp->nlink--;
    80004ba2:	04a4d783          	lhu	a5,74(s1)
    80004ba6:	37fd                	addiw	a5,a5,-1
    80004ba8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	fc2080e7          	jalr	-62(ra) # 80002b70 <iupdate>
    80004bb6:	b781                	j	80004af6 <sys_unlink+0xe0>
    return -1;
    80004bb8:	557d                	li	a0,-1
    80004bba:	a005                	j	80004bda <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bbc:	854a                	mv	a0,s2
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	2e0080e7          	jalr	736(ra) # 80002e9e <iunlockput>
  iunlockput(dp);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	2d6080e7          	jalr	726(ra) # 80002e9e <iunlockput>
  end_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	ab6080e7          	jalr	-1354(ra) # 80003686 <end_op>
  return -1;
    80004bd8:	557d                	li	a0,-1
}
    80004bda:	70ae                	ld	ra,232(sp)
    80004bdc:	740e                	ld	s0,224(sp)
    80004bde:	64ee                	ld	s1,216(sp)
    80004be0:	694e                	ld	s2,208(sp)
    80004be2:	69ae                	ld	s3,200(sp)
    80004be4:	616d                	addi	sp,sp,240
    80004be6:	8082                	ret

0000000080004be8 <sys_open>:

uint64
sys_open(void)
{
    80004be8:	7131                	addi	sp,sp,-192
    80004bea:	fd06                	sd	ra,184(sp)
    80004bec:	f922                	sd	s0,176(sp)
    80004bee:	f526                	sd	s1,168(sp)
    80004bf0:	f14a                	sd	s2,160(sp)
    80004bf2:	ed4e                	sd	s3,152(sp)
    80004bf4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bf6:	f4c40593          	addi	a1,s0,-180
    80004bfa:	4505                	li	a0,1
    80004bfc:	ffffd097          	auipc	ra,0xffffd
    80004c00:	42e080e7          	jalr	1070(ra) # 8000202a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c04:	08000613          	li	a2,128
    80004c08:	f5040593          	addi	a1,s0,-176
    80004c0c:	4501                	li	a0,0
    80004c0e:	ffffd097          	auipc	ra,0xffffd
    80004c12:	45c080e7          	jalr	1116(ra) # 8000206a <argstr>
    80004c16:	87aa                	mv	a5,a0
    return -1;
    80004c18:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c1a:	0a07c963          	bltz	a5,80004ccc <sys_open+0xe4>

  begin_op();
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	9ea080e7          	jalr	-1558(ra) # 80003608 <begin_op>

  if(omode & O_CREATE){
    80004c26:	f4c42783          	lw	a5,-180(s0)
    80004c2a:	2007f793          	andi	a5,a5,512
    80004c2e:	cfc5                	beqz	a5,80004ce6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c30:	4681                	li	a3,0
    80004c32:	4601                	li	a2,0
    80004c34:	4589                	li	a1,2
    80004c36:	f5040513          	addi	a0,s0,-176
    80004c3a:	00000097          	auipc	ra,0x0
    80004c3e:	970080e7          	jalr	-1680(ra) # 800045aa <create>
    80004c42:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c44:	c959                	beqz	a0,80004cda <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c46:	04449703          	lh	a4,68(s1)
    80004c4a:	478d                	li	a5,3
    80004c4c:	00f71763          	bne	a4,a5,80004c5a <sys_open+0x72>
    80004c50:	0464d703          	lhu	a4,70(s1)
    80004c54:	47a5                	li	a5,9
    80004c56:	0ce7ed63          	bltu	a5,a4,80004d30 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	dba080e7          	jalr	-582(ra) # 80003a14 <filealloc>
    80004c62:	89aa                	mv	s3,a0
    80004c64:	10050363          	beqz	a0,80004d6a <sys_open+0x182>
    80004c68:	00000097          	auipc	ra,0x0
    80004c6c:	900080e7          	jalr	-1792(ra) # 80004568 <fdalloc>
    80004c70:	892a                	mv	s2,a0
    80004c72:	0e054763          	bltz	a0,80004d60 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c76:	04449703          	lh	a4,68(s1)
    80004c7a:	478d                	li	a5,3
    80004c7c:	0cf70563          	beq	a4,a5,80004d46 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c80:	4789                	li	a5,2
    80004c82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c8a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c8e:	f4c42783          	lw	a5,-180(s0)
    80004c92:	0017c713          	xori	a4,a5,1
    80004c96:	8b05                	andi	a4,a4,1
    80004c98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c9c:	0037f713          	andi	a4,a5,3
    80004ca0:	00e03733          	snez	a4,a4
    80004ca4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ca8:	4007f793          	andi	a5,a5,1024
    80004cac:	c791                	beqz	a5,80004cb8 <sys_open+0xd0>
    80004cae:	04449703          	lh	a4,68(s1)
    80004cb2:	4789                	li	a5,2
    80004cb4:	0af70063          	beq	a4,a5,80004d54 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cb8:	8526                	mv	a0,s1
    80004cba:	ffffe097          	auipc	ra,0xffffe
    80004cbe:	044080e7          	jalr	68(ra) # 80002cfe <iunlock>
  end_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	9c4080e7          	jalr	-1596(ra) # 80003686 <end_op>

  return fd;
    80004cca:	854a                	mv	a0,s2
}
    80004ccc:	70ea                	ld	ra,184(sp)
    80004cce:	744a                	ld	s0,176(sp)
    80004cd0:	74aa                	ld	s1,168(sp)
    80004cd2:	790a                	ld	s2,160(sp)
    80004cd4:	69ea                	ld	s3,152(sp)
    80004cd6:	6129                	addi	sp,sp,192
    80004cd8:	8082                	ret
      end_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	9ac080e7          	jalr	-1620(ra) # 80003686 <end_op>
      return -1;
    80004ce2:	557d                	li	a0,-1
    80004ce4:	b7e5                	j	80004ccc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004ce6:	f5040513          	addi	a0,s0,-176
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	6fe080e7          	jalr	1790(ra) # 800033e8 <namei>
    80004cf2:	84aa                	mv	s1,a0
    80004cf4:	c905                	beqz	a0,80004d24 <sys_open+0x13c>
    ilock(ip);
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	f46080e7          	jalr	-186(ra) # 80002c3c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cfe:	04449703          	lh	a4,68(s1)
    80004d02:	4785                	li	a5,1
    80004d04:	f4f711e3          	bne	a4,a5,80004c46 <sys_open+0x5e>
    80004d08:	f4c42783          	lw	a5,-180(s0)
    80004d0c:	d7b9                	beqz	a5,80004c5a <sys_open+0x72>
      iunlockput(ip);
    80004d0e:	8526                	mv	a0,s1
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	18e080e7          	jalr	398(ra) # 80002e9e <iunlockput>
      end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	96e080e7          	jalr	-1682(ra) # 80003686 <end_op>
      return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	b76d                	j	80004ccc <sys_open+0xe4>
      end_op();
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	962080e7          	jalr	-1694(ra) # 80003686 <end_op>
      return -1;
    80004d2c:	557d                	li	a0,-1
    80004d2e:	bf79                	j	80004ccc <sys_open+0xe4>
    iunlockput(ip);
    80004d30:	8526                	mv	a0,s1
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	16c080e7          	jalr	364(ra) # 80002e9e <iunlockput>
    end_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	94c080e7          	jalr	-1716(ra) # 80003686 <end_op>
    return -1;
    80004d42:	557d                	li	a0,-1
    80004d44:	b761                	j	80004ccc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d46:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d4a:	04649783          	lh	a5,70(s1)
    80004d4e:	02f99223          	sh	a5,36(s3)
    80004d52:	bf25                	j	80004c8a <sys_open+0xa2>
    itrunc(ip);
    80004d54:	8526                	mv	a0,s1
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	ff4080e7          	jalr	-12(ra) # 80002d4a <itrunc>
    80004d5e:	bfa9                	j	80004cb8 <sys_open+0xd0>
      fileclose(f);
    80004d60:	854e                	mv	a0,s3
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	d6e080e7          	jalr	-658(ra) # 80003ad0 <fileclose>
    iunlockput(ip);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	132080e7          	jalr	306(ra) # 80002e9e <iunlockput>
    end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	912080e7          	jalr	-1774(ra) # 80003686 <end_op>
    return -1;
    80004d7c:	557d                	li	a0,-1
    80004d7e:	b7b9                	j	80004ccc <sys_open+0xe4>

0000000080004d80 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d80:	7175                	addi	sp,sp,-144
    80004d82:	e506                	sd	ra,136(sp)
    80004d84:	e122                	sd	s0,128(sp)
    80004d86:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	880080e7          	jalr	-1920(ra) # 80003608 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d90:	08000613          	li	a2,128
    80004d94:	f7040593          	addi	a1,s0,-144
    80004d98:	4501                	li	a0,0
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	2d0080e7          	jalr	720(ra) # 8000206a <argstr>
    80004da2:	02054963          	bltz	a0,80004dd4 <sys_mkdir+0x54>
    80004da6:	4681                	li	a3,0
    80004da8:	4601                	li	a2,0
    80004daa:	4585                	li	a1,1
    80004dac:	f7040513          	addi	a0,s0,-144
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	7fa080e7          	jalr	2042(ra) # 800045aa <create>
    80004db8:	cd11                	beqz	a0,80004dd4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	0e4080e7          	jalr	228(ra) # 80002e9e <iunlockput>
  end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	8c4080e7          	jalr	-1852(ra) # 80003686 <end_op>
  return 0;
    80004dca:	4501                	li	a0,0
}
    80004dcc:	60aa                	ld	ra,136(sp)
    80004dce:	640a                	ld	s0,128(sp)
    80004dd0:	6149                	addi	sp,sp,144
    80004dd2:	8082                	ret
    end_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	8b2080e7          	jalr	-1870(ra) # 80003686 <end_op>
    return -1;
    80004ddc:	557d                	li	a0,-1
    80004dde:	b7fd                	j	80004dcc <sys_mkdir+0x4c>

0000000080004de0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004de0:	7135                	addi	sp,sp,-160
    80004de2:	ed06                	sd	ra,152(sp)
    80004de4:	e922                	sd	s0,144(sp)
    80004de6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	820080e7          	jalr	-2016(ra) # 80003608 <begin_op>
  argint(1, &major);
    80004df0:	f6c40593          	addi	a1,s0,-148
    80004df4:	4505                	li	a0,1
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	234080e7          	jalr	564(ra) # 8000202a <argint>
  argint(2, &minor);
    80004dfe:	f6840593          	addi	a1,s0,-152
    80004e02:	4509                	li	a0,2
    80004e04:	ffffd097          	auipc	ra,0xffffd
    80004e08:	226080e7          	jalr	550(ra) # 8000202a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e0c:	08000613          	li	a2,128
    80004e10:	f7040593          	addi	a1,s0,-144
    80004e14:	4501                	li	a0,0
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	254080e7          	jalr	596(ra) # 8000206a <argstr>
    80004e1e:	02054b63          	bltz	a0,80004e54 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e22:	f6841683          	lh	a3,-152(s0)
    80004e26:	f6c41603          	lh	a2,-148(s0)
    80004e2a:	458d                	li	a1,3
    80004e2c:	f7040513          	addi	a0,s0,-144
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	77a080e7          	jalr	1914(ra) # 800045aa <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e38:	cd11                	beqz	a0,80004e54 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	064080e7          	jalr	100(ra) # 80002e9e <iunlockput>
  end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	844080e7          	jalr	-1980(ra) # 80003686 <end_op>
  return 0;
    80004e4a:	4501                	li	a0,0
}
    80004e4c:	60ea                	ld	ra,152(sp)
    80004e4e:	644a                	ld	s0,144(sp)
    80004e50:	610d                	addi	sp,sp,160
    80004e52:	8082                	ret
    end_op();
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	832080e7          	jalr	-1998(ra) # 80003686 <end_op>
    return -1;
    80004e5c:	557d                	li	a0,-1
    80004e5e:	b7fd                	j	80004e4c <sys_mknod+0x6c>

0000000080004e60 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e60:	7135                	addi	sp,sp,-160
    80004e62:	ed06                	sd	ra,152(sp)
    80004e64:	e922                	sd	s0,144(sp)
    80004e66:	e526                	sd	s1,136(sp)
    80004e68:	e14a                	sd	s2,128(sp)
    80004e6a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e6c:	ffffc097          	auipc	ra,0xffffc
    80004e70:	fe6080e7          	jalr	-26(ra) # 80000e52 <myproc>
    80004e74:	892a                	mv	s2,a0
  
  begin_op();
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	792080e7          	jalr	1938(ra) # 80003608 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e7e:	08000613          	li	a2,128
    80004e82:	f6040593          	addi	a1,s0,-160
    80004e86:	4501                	li	a0,0
    80004e88:	ffffd097          	auipc	ra,0xffffd
    80004e8c:	1e2080e7          	jalr	482(ra) # 8000206a <argstr>
    80004e90:	04054b63          	bltz	a0,80004ee6 <sys_chdir+0x86>
    80004e94:	f6040513          	addi	a0,s0,-160
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	550080e7          	jalr	1360(ra) # 800033e8 <namei>
    80004ea0:	84aa                	mv	s1,a0
    80004ea2:	c131                	beqz	a0,80004ee6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	d98080e7          	jalr	-616(ra) # 80002c3c <ilock>
  if(ip->type != T_DIR){
    80004eac:	04449703          	lh	a4,68(s1)
    80004eb0:	4785                	li	a5,1
    80004eb2:	04f71063          	bne	a4,a5,80004ef2 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	e46080e7          	jalr	-442(ra) # 80002cfe <iunlock>
  iput(p->cwd);
    80004ec0:	29093503          	ld	a0,656(s2)
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	f32080e7          	jalr	-206(ra) # 80002df6 <iput>
  end_op();
    80004ecc:	ffffe097          	auipc	ra,0xffffe
    80004ed0:	7ba080e7          	jalr	1978(ra) # 80003686 <end_op>
  p->cwd = ip;
    80004ed4:	28993823          	sd	s1,656(s2)
  return 0;
    80004ed8:	4501                	li	a0,0
}
    80004eda:	60ea                	ld	ra,152(sp)
    80004edc:	644a                	ld	s0,144(sp)
    80004ede:	64aa                	ld	s1,136(sp)
    80004ee0:	690a                	ld	s2,128(sp)
    80004ee2:	610d                	addi	sp,sp,160
    80004ee4:	8082                	ret
    end_op();
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	7a0080e7          	jalr	1952(ra) # 80003686 <end_op>
    return -1;
    80004eee:	557d                	li	a0,-1
    80004ef0:	b7ed                	j	80004eda <sys_chdir+0x7a>
    iunlockput(ip);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	faa080e7          	jalr	-86(ra) # 80002e9e <iunlockput>
    end_op();
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	78a080e7          	jalr	1930(ra) # 80003686 <end_op>
    return -1;
    80004f04:	557d                	li	a0,-1
    80004f06:	bfd1                	j	80004eda <sys_chdir+0x7a>

0000000080004f08 <sys_exec>:

uint64
sys_exec(void)
{
    80004f08:	7145                	addi	sp,sp,-464
    80004f0a:	e786                	sd	ra,456(sp)
    80004f0c:	e3a2                	sd	s0,448(sp)
    80004f0e:	ff26                	sd	s1,440(sp)
    80004f10:	fb4a                	sd	s2,432(sp)
    80004f12:	f74e                	sd	s3,424(sp)
    80004f14:	f352                	sd	s4,416(sp)
    80004f16:	ef56                	sd	s5,408(sp)
    80004f18:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f1a:	e3840593          	addi	a1,s0,-456
    80004f1e:	4505                	li	a0,1
    80004f20:	ffffd097          	auipc	ra,0xffffd
    80004f24:	12a080e7          	jalr	298(ra) # 8000204a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f28:	08000613          	li	a2,128
    80004f2c:	f4040593          	addi	a1,s0,-192
    80004f30:	4501                	li	a0,0
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	138080e7          	jalr	312(ra) # 8000206a <argstr>
    80004f3a:	87aa                	mv	a5,a0
    return -1;
    80004f3c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f3e:	0c07c363          	bltz	a5,80005004 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004f42:	10000613          	li	a2,256
    80004f46:	4581                	li	a1,0
    80004f48:	e4040513          	addi	a0,s0,-448
    80004f4c:	ffffb097          	auipc	ra,0xffffb
    80004f50:	22e080e7          	jalr	558(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f54:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f58:	89a6                	mv	s3,s1
    80004f5a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f5c:	02000a13          	li	s4,32
    80004f60:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f64:	00391513          	slli	a0,s2,0x3
    80004f68:	e3040593          	addi	a1,s0,-464
    80004f6c:	e3843783          	ld	a5,-456(s0)
    80004f70:	953e                	add	a0,a0,a5
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	014080e7          	jalr	20(ra) # 80001f86 <fetchaddr>
    80004f7a:	02054a63          	bltz	a0,80004fae <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f7e:	e3043783          	ld	a5,-464(s0)
    80004f82:	c3b9                	beqz	a5,80004fc8 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f84:	ffffb097          	auipc	ra,0xffffb
    80004f88:	196080e7          	jalr	406(ra) # 8000011a <kalloc>
    80004f8c:	85aa                	mv	a1,a0
    80004f8e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f92:	cd11                	beqz	a0,80004fae <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f94:	6605                	lui	a2,0x1
    80004f96:	e3043503          	ld	a0,-464(s0)
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	042080e7          	jalr	66(ra) # 80001fdc <fetchstr>
    80004fa2:	00054663          	bltz	a0,80004fae <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fa6:	0905                	addi	s2,s2,1
    80004fa8:	09a1                	addi	s3,s3,8
    80004faa:	fb491be3          	bne	s2,s4,80004f60 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fae:	f4040913          	addi	s2,s0,-192
    80004fb2:	6088                	ld	a0,0(s1)
    80004fb4:	c539                	beqz	a0,80005002 <sys_exec+0xfa>
    kfree(argv[i]);
    80004fb6:	ffffb097          	auipc	ra,0xffffb
    80004fba:	066080e7          	jalr	102(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fbe:	04a1                	addi	s1,s1,8
    80004fc0:	ff2499e3          	bne	s1,s2,80004fb2 <sys_exec+0xaa>
  return -1;
    80004fc4:	557d                	li	a0,-1
    80004fc6:	a83d                	j	80005004 <sys_exec+0xfc>
      argv[i] = 0;
    80004fc8:	0a8e                	slli	s5,s5,0x3
    80004fca:	fc0a8793          	addi	a5,s5,-64
    80004fce:	00878ab3          	add	s5,a5,s0
    80004fd2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fd6:	e4040593          	addi	a1,s0,-448
    80004fda:	f4040513          	addi	a0,s0,-192
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	16c080e7          	jalr	364(ra) # 8000414a <exec>
    80004fe6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe8:	f4040993          	addi	s3,s0,-192
    80004fec:	6088                	ld	a0,0(s1)
    80004fee:	c901                	beqz	a0,80004ffe <sys_exec+0xf6>
    kfree(argv[i]);
    80004ff0:	ffffb097          	auipc	ra,0xffffb
    80004ff4:	02c080e7          	jalr	44(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff8:	04a1                	addi	s1,s1,8
    80004ffa:	ff3499e3          	bne	s1,s3,80004fec <sys_exec+0xe4>
  return ret;
    80004ffe:	854a                	mv	a0,s2
    80005000:	a011                	j	80005004 <sys_exec+0xfc>
  return -1;
    80005002:	557d                	li	a0,-1
}
    80005004:	60be                	ld	ra,456(sp)
    80005006:	641e                	ld	s0,448(sp)
    80005008:	74fa                	ld	s1,440(sp)
    8000500a:	795a                	ld	s2,432(sp)
    8000500c:	79ba                	ld	s3,424(sp)
    8000500e:	7a1a                	ld	s4,416(sp)
    80005010:	6afa                	ld	s5,408(sp)
    80005012:	6179                	addi	sp,sp,464
    80005014:	8082                	ret

0000000080005016 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005016:	7139                	addi	sp,sp,-64
    80005018:	fc06                	sd	ra,56(sp)
    8000501a:	f822                	sd	s0,48(sp)
    8000501c:	f426                	sd	s1,40(sp)
    8000501e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005020:	ffffc097          	auipc	ra,0xffffc
    80005024:	e32080e7          	jalr	-462(ra) # 80000e52 <myproc>
    80005028:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000502a:	fd840593          	addi	a1,s0,-40
    8000502e:	4501                	li	a0,0
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	01a080e7          	jalr	26(ra) # 8000204a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005038:	fc840593          	addi	a1,s0,-56
    8000503c:	fd040513          	addi	a0,s0,-48
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	dc0080e7          	jalr	-576(ra) # 80003e00 <pipealloc>
    return -1;
    80005048:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000504a:	0c054963          	bltz	a0,8000511c <sys_pipe+0x106>
  fd0 = -1;
    8000504e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005052:	fd043503          	ld	a0,-48(s0)
    80005056:	fffff097          	auipc	ra,0xfffff
    8000505a:	512080e7          	jalr	1298(ra) # 80004568 <fdalloc>
    8000505e:	fca42223          	sw	a0,-60(s0)
    80005062:	0a054063          	bltz	a0,80005102 <sys_pipe+0xec>
    80005066:	fc843503          	ld	a0,-56(s0)
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	4fe080e7          	jalr	1278(ra) # 80004568 <fdalloc>
    80005072:	fca42023          	sw	a0,-64(s0)
    80005076:	06054c63          	bltz	a0,800050ee <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000507a:	4691                	li	a3,4
    8000507c:	fc440613          	addi	a2,s0,-60
    80005080:	fd843583          	ld	a1,-40(s0)
    80005084:	1884b503          	ld	a0,392(s1)
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	a8c080e7          	jalr	-1396(ra) # 80000b14 <copyout>
    80005090:	02054163          	bltz	a0,800050b2 <sys_pipe+0x9c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005094:	4691                	li	a3,4
    80005096:	fc040613          	addi	a2,s0,-64
    8000509a:	fd843583          	ld	a1,-40(s0)
    8000509e:	0591                	addi	a1,a1,4
    800050a0:	1884b503          	ld	a0,392(s1)
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	a70080e7          	jalr	-1424(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050ac:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ae:	06055763          	bgez	a0,8000511c <sys_pipe+0x106>
    p->ofile[fd0] = 0;
    800050b2:	fc442783          	lw	a5,-60(s0)
    800050b6:	04278793          	addi	a5,a5,66
    800050ba:	078e                	slli	a5,a5,0x3
    800050bc:	97a6                	add	a5,a5,s1
    800050be:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050c2:	fc042783          	lw	a5,-64(s0)
    800050c6:	04278793          	addi	a5,a5,66
    800050ca:	078e                	slli	a5,a5,0x3
    800050cc:	94be                	add	s1,s1,a5
    800050ce:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050d2:	fd043503          	ld	a0,-48(s0)
    800050d6:	fffff097          	auipc	ra,0xfffff
    800050da:	9fa080e7          	jalr	-1542(ra) # 80003ad0 <fileclose>
    fileclose(wf);
    800050de:	fc843503          	ld	a0,-56(s0)
    800050e2:	fffff097          	auipc	ra,0xfffff
    800050e6:	9ee080e7          	jalr	-1554(ra) # 80003ad0 <fileclose>
    return -1;
    800050ea:	57fd                	li	a5,-1
    800050ec:	a805                	j	8000511c <sys_pipe+0x106>
    if(fd0 >= 0)
    800050ee:	fc442783          	lw	a5,-60(s0)
    800050f2:	0007c863          	bltz	a5,80005102 <sys_pipe+0xec>
      p->ofile[fd0] = 0;
    800050f6:	04278793          	addi	a5,a5,66
    800050fa:	078e                	slli	a5,a5,0x3
    800050fc:	97a6                	add	a5,a5,s1
    800050fe:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005102:	fd043503          	ld	a0,-48(s0)
    80005106:	fffff097          	auipc	ra,0xfffff
    8000510a:	9ca080e7          	jalr	-1590(ra) # 80003ad0 <fileclose>
    fileclose(wf);
    8000510e:	fc843503          	ld	a0,-56(s0)
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	9be080e7          	jalr	-1602(ra) # 80003ad0 <fileclose>
    return -1;
    8000511a:	57fd                	li	a5,-1
}
    8000511c:	853e                	mv	a0,a5
    8000511e:	70e2                	ld	ra,56(sp)
    80005120:	7442                	ld	s0,48(sp)
    80005122:	74a2                	ld	s1,40(sp)
    80005124:	6121                	addi	sp,sp,64
    80005126:	8082                	ret
	...

0000000080005130 <kernelvec>:
    80005130:	7111                	addi	sp,sp,-256
    80005132:	e006                	sd	ra,0(sp)
    80005134:	e40a                	sd	sp,8(sp)
    80005136:	e80e                	sd	gp,16(sp)
    80005138:	ec12                	sd	tp,24(sp)
    8000513a:	f016                	sd	t0,32(sp)
    8000513c:	f41a                	sd	t1,40(sp)
    8000513e:	f81e                	sd	t2,48(sp)
    80005140:	fc22                	sd	s0,56(sp)
    80005142:	e0a6                	sd	s1,64(sp)
    80005144:	e4aa                	sd	a0,72(sp)
    80005146:	e8ae                	sd	a1,80(sp)
    80005148:	ecb2                	sd	a2,88(sp)
    8000514a:	f0b6                	sd	a3,96(sp)
    8000514c:	f4ba                	sd	a4,104(sp)
    8000514e:	f8be                	sd	a5,112(sp)
    80005150:	fcc2                	sd	a6,120(sp)
    80005152:	e146                	sd	a7,128(sp)
    80005154:	e54a                	sd	s2,136(sp)
    80005156:	e94e                	sd	s3,144(sp)
    80005158:	ed52                	sd	s4,152(sp)
    8000515a:	f156                	sd	s5,160(sp)
    8000515c:	f55a                	sd	s6,168(sp)
    8000515e:	f95e                	sd	s7,176(sp)
    80005160:	fd62                	sd	s8,184(sp)
    80005162:	e1e6                	sd	s9,192(sp)
    80005164:	e5ea                	sd	s10,200(sp)
    80005166:	e9ee                	sd	s11,208(sp)
    80005168:	edf2                	sd	t3,216(sp)
    8000516a:	f1f6                	sd	t4,224(sp)
    8000516c:	f5fa                	sd	t5,232(sp)
    8000516e:	f9fe                	sd	t6,240(sp)
    80005170:	cd7fc0ef          	jal	ra,80001e46 <kerneltrap>
    80005174:	6082                	ld	ra,0(sp)
    80005176:	6122                	ld	sp,8(sp)
    80005178:	61c2                	ld	gp,16(sp)
    8000517a:	7282                	ld	t0,32(sp)
    8000517c:	7322                	ld	t1,40(sp)
    8000517e:	73c2                	ld	t2,48(sp)
    80005180:	7462                	ld	s0,56(sp)
    80005182:	6486                	ld	s1,64(sp)
    80005184:	6526                	ld	a0,72(sp)
    80005186:	65c6                	ld	a1,80(sp)
    80005188:	6666                	ld	a2,88(sp)
    8000518a:	7686                	ld	a3,96(sp)
    8000518c:	7726                	ld	a4,104(sp)
    8000518e:	77c6                	ld	a5,112(sp)
    80005190:	7866                	ld	a6,120(sp)
    80005192:	688a                	ld	a7,128(sp)
    80005194:	692a                	ld	s2,136(sp)
    80005196:	69ca                	ld	s3,144(sp)
    80005198:	6a6a                	ld	s4,152(sp)
    8000519a:	7a8a                	ld	s5,160(sp)
    8000519c:	7b2a                	ld	s6,168(sp)
    8000519e:	7bca                	ld	s7,176(sp)
    800051a0:	7c6a                	ld	s8,184(sp)
    800051a2:	6c8e                	ld	s9,192(sp)
    800051a4:	6d2e                	ld	s10,200(sp)
    800051a6:	6dce                	ld	s11,208(sp)
    800051a8:	6e6e                	ld	t3,216(sp)
    800051aa:	7e8e                	ld	t4,224(sp)
    800051ac:	7f2e                	ld	t5,232(sp)
    800051ae:	7fce                	ld	t6,240(sp)
    800051b0:	6111                	addi	sp,sp,256
    800051b2:	10200073          	sret
    800051b6:	00000013          	nop
    800051ba:	00000013          	nop
    800051be:	0001                	nop

00000000800051c0 <timervec>:
    800051c0:	34051573          	csrrw	a0,mscratch,a0
    800051c4:	e10c                	sd	a1,0(a0)
    800051c6:	e510                	sd	a2,8(a0)
    800051c8:	e914                	sd	a3,16(a0)
    800051ca:	6d0c                	ld	a1,24(a0)
    800051cc:	7110                	ld	a2,32(a0)
    800051ce:	6194                	ld	a3,0(a1)
    800051d0:	96b2                	add	a3,a3,a2
    800051d2:	e194                	sd	a3,0(a1)
    800051d4:	4589                	li	a1,2
    800051d6:	14459073          	csrw	sip,a1
    800051da:	6914                	ld	a3,16(a0)
    800051dc:	6510                	ld	a2,8(a0)
    800051de:	610c                	ld	a1,0(a0)
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	30200073          	mret
	...

00000000800051ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ea:	1141                	addi	sp,sp,-16
    800051ec:	e422                	sd	s0,8(sp)
    800051ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051f0:	0c0007b7          	lui	a5,0xc000
    800051f4:	4705                	li	a4,1
    800051f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051f8:	c3d8                	sw	a4,4(a5)
}
    800051fa:	6422                	ld	s0,8(sp)
    800051fc:	0141                	addi	sp,sp,16
    800051fe:	8082                	ret

0000000080005200 <plicinithart>:

void
plicinithart(void)
{
    80005200:	1141                	addi	sp,sp,-16
    80005202:	e406                	sd	ra,8(sp)
    80005204:	e022                	sd	s0,0(sp)
    80005206:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	c1e080e7          	jalr	-994(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005210:	0085171b          	slliw	a4,a0,0x8
    80005214:	0c0027b7          	lui	a5,0xc002
    80005218:	97ba                	add	a5,a5,a4
    8000521a:	40200713          	li	a4,1026
    8000521e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005222:	00d5151b          	slliw	a0,a0,0xd
    80005226:	0c2017b7          	lui	a5,0xc201
    8000522a:	97aa                	add	a5,a5,a0
    8000522c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005230:	60a2                	ld	ra,8(sp)
    80005232:	6402                	ld	s0,0(sp)
    80005234:	0141                	addi	sp,sp,16
    80005236:	8082                	ret

0000000080005238 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005238:	1141                	addi	sp,sp,-16
    8000523a:	e406                	sd	ra,8(sp)
    8000523c:	e022                	sd	s0,0(sp)
    8000523e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	be6080e7          	jalr	-1050(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005248:	00d5151b          	slliw	a0,a0,0xd
    8000524c:	0c2017b7          	lui	a5,0xc201
    80005250:	97aa                	add	a5,a5,a0
  return irq;
}
    80005252:	43c8                	lw	a0,4(a5)
    80005254:	60a2                	ld	ra,8(sp)
    80005256:	6402                	ld	s0,0(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret

000000008000525c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000525c:	1101                	addi	sp,sp,-32
    8000525e:	ec06                	sd	ra,24(sp)
    80005260:	e822                	sd	s0,16(sp)
    80005262:	e426                	sd	s1,8(sp)
    80005264:	1000                	addi	s0,sp,32
    80005266:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	bbe080e7          	jalr	-1090(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005270:	00d5151b          	slliw	a0,a0,0xd
    80005274:	0c2017b7          	lui	a5,0xc201
    80005278:	97aa                	add	a5,a5,a0
    8000527a:	c3c4                	sw	s1,4(a5)
}
    8000527c:	60e2                	ld	ra,24(sp)
    8000527e:	6442                	ld	s0,16(sp)
    80005280:	64a2                	ld	s1,8(sp)
    80005282:	6105                	addi	sp,sp,32
    80005284:	8082                	ret

0000000080005286 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005286:	1141                	addi	sp,sp,-16
    80005288:	e406                	sd	ra,8(sp)
    8000528a:	e022                	sd	s0,0(sp)
    8000528c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000528e:	479d                	li	a5,7
    80005290:	04a7cc63          	blt	a5,a0,800052e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005294:	00019797          	auipc	a5,0x19
    80005298:	76c78793          	addi	a5,a5,1900 # 8001ea00 <disk>
    8000529c:	97aa                	add	a5,a5,a0
    8000529e:	0187c783          	lbu	a5,24(a5)
    800052a2:	ebb9                	bnez	a5,800052f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052a4:	00451693          	slli	a3,a0,0x4
    800052a8:	00019797          	auipc	a5,0x19
    800052ac:	75878793          	addi	a5,a5,1880 # 8001ea00 <disk>
    800052b0:	6398                	ld	a4,0(a5)
    800052b2:	9736                	add	a4,a4,a3
    800052b4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052b8:	6398                	ld	a4,0(a5)
    800052ba:	9736                	add	a4,a4,a3
    800052bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052c8:	97aa                	add	a5,a5,a0
    800052ca:	4705                	li	a4,1
    800052cc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052d0:	00019517          	auipc	a0,0x19
    800052d4:	74850513          	addi	a0,a0,1864 # 8001ea18 <disk+0x18>
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	2ba080e7          	jalr	698(ra) # 80001592 <wakeup>
}
    800052e0:	60a2                	ld	ra,8(sp)
    800052e2:	6402                	ld	s0,0(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret
    panic("free_desc 1");
    800052e8:	00003517          	auipc	a0,0x3
    800052ec:	3f850513          	addi	a0,a0,1016 # 800086e0 <syscalls+0x310>
    800052f0:	00001097          	auipc	ra,0x1
    800052f4:	a0c080e7          	jalr	-1524(ra) # 80005cfc <panic>
    panic("free_desc 2");
    800052f8:	00003517          	auipc	a0,0x3
    800052fc:	3f850513          	addi	a0,a0,1016 # 800086f0 <syscalls+0x320>
    80005300:	00001097          	auipc	ra,0x1
    80005304:	9fc080e7          	jalr	-1540(ra) # 80005cfc <panic>

0000000080005308 <virtio_disk_init>:
{
    80005308:	1101                	addi	sp,sp,-32
    8000530a:	ec06                	sd	ra,24(sp)
    8000530c:	e822                	sd	s0,16(sp)
    8000530e:	e426                	sd	s1,8(sp)
    80005310:	e04a                	sd	s2,0(sp)
    80005312:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005314:	00003597          	auipc	a1,0x3
    80005318:	3ec58593          	addi	a1,a1,1004 # 80008700 <syscalls+0x330>
    8000531c:	0001a517          	auipc	a0,0x1a
    80005320:	80c50513          	addi	a0,a0,-2036 # 8001eb28 <disk+0x128>
    80005324:	00001097          	auipc	ra,0x1
    80005328:	ecc080e7          	jalr	-308(ra) # 800061f0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	4398                	lw	a4,0(a5)
    80005332:	2701                	sext.w	a4,a4
    80005334:	747277b7          	lui	a5,0x74727
    80005338:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000533c:	14f71b63          	bne	a4,a5,80005492 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005340:	100017b7          	lui	a5,0x10001
    80005344:	43dc                	lw	a5,4(a5)
    80005346:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005348:	4709                	li	a4,2
    8000534a:	14e79463          	bne	a5,a4,80005492 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000534e:	100017b7          	lui	a5,0x10001
    80005352:	479c                	lw	a5,8(a5)
    80005354:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005356:	12e79e63          	bne	a5,a4,80005492 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000535a:	100017b7          	lui	a5,0x10001
    8000535e:	47d8                	lw	a4,12(a5)
    80005360:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005362:	554d47b7          	lui	a5,0x554d4
    80005366:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000536a:	12f71463          	bne	a4,a5,80005492 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000536e:	100017b7          	lui	a5,0x10001
    80005372:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005376:	4705                	li	a4,1
    80005378:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000537a:	470d                	li	a4,3
    8000537c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000537e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005380:	c7ffe6b7          	lui	a3,0xc7ffe
    80005384:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd79df>
    80005388:	8f75                	and	a4,a4,a3
    8000538a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538c:	472d                	li	a4,11
    8000538e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005390:	5bbc                	lw	a5,112(a5)
    80005392:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005396:	8ba1                	andi	a5,a5,8
    80005398:	10078563          	beqz	a5,800054a2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053a4:	43fc                	lw	a5,68(a5)
    800053a6:	2781                	sext.w	a5,a5
    800053a8:	10079563          	bnez	a5,800054b2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053ac:	100017b7          	lui	a5,0x10001
    800053b0:	5bdc                	lw	a5,52(a5)
    800053b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800053b4:	10078763          	beqz	a5,800054c2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800053b8:	471d                	li	a4,7
    800053ba:	10f77c63          	bgeu	a4,a5,800054d2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800053be:	ffffb097          	auipc	ra,0xffffb
    800053c2:	d5c080e7          	jalr	-676(ra) # 8000011a <kalloc>
    800053c6:	00019497          	auipc	s1,0x19
    800053ca:	63a48493          	addi	s1,s1,1594 # 8001ea00 <disk>
    800053ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053d0:	ffffb097          	auipc	ra,0xffffb
    800053d4:	d4a080e7          	jalr	-694(ra) # 8000011a <kalloc>
    800053d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053da:	ffffb097          	auipc	ra,0xffffb
    800053de:	d40080e7          	jalr	-704(ra) # 8000011a <kalloc>
    800053e2:	87aa                	mv	a5,a0
    800053e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053e6:	6088                	ld	a0,0(s1)
    800053e8:	cd6d                	beqz	a0,800054e2 <virtio_disk_init+0x1da>
    800053ea:	00019717          	auipc	a4,0x19
    800053ee:	61e73703          	ld	a4,1566(a4) # 8001ea08 <disk+0x8>
    800053f2:	cb65                	beqz	a4,800054e2 <virtio_disk_init+0x1da>
    800053f4:	c7fd                	beqz	a5,800054e2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053f6:	6605                	lui	a2,0x1
    800053f8:	4581                	li	a1,0
    800053fa:	ffffb097          	auipc	ra,0xffffb
    800053fe:	d80080e7          	jalr	-640(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005402:	00019497          	auipc	s1,0x19
    80005406:	5fe48493          	addi	s1,s1,1534 # 8001ea00 <disk>
    8000540a:	6605                	lui	a2,0x1
    8000540c:	4581                	li	a1,0
    8000540e:	6488                	ld	a0,8(s1)
    80005410:	ffffb097          	auipc	ra,0xffffb
    80005414:	d6a080e7          	jalr	-662(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005418:	6605                	lui	a2,0x1
    8000541a:	4581                	li	a1,0
    8000541c:	6888                	ld	a0,16(s1)
    8000541e:	ffffb097          	auipc	ra,0xffffb
    80005422:	d5c080e7          	jalr	-676(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	4721                	li	a4,8
    8000542c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000542e:	4098                	lw	a4,0(s1)
    80005430:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005434:	40d8                	lw	a4,4(s1)
    80005436:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000543a:	6498                	ld	a4,8(s1)
    8000543c:	0007069b          	sext.w	a3,a4
    80005440:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005444:	9701                	srai	a4,a4,0x20
    80005446:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000544a:	6898                	ld	a4,16(s1)
    8000544c:	0007069b          	sext.w	a3,a4
    80005450:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005454:	9701                	srai	a4,a4,0x20
    80005456:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000545a:	4705                	li	a4,1
    8000545c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000545e:	00e48c23          	sb	a4,24(s1)
    80005462:	00e48ca3          	sb	a4,25(s1)
    80005466:	00e48d23          	sb	a4,26(s1)
    8000546a:	00e48da3          	sb	a4,27(s1)
    8000546e:	00e48e23          	sb	a4,28(s1)
    80005472:	00e48ea3          	sb	a4,29(s1)
    80005476:	00e48f23          	sb	a4,30(s1)
    8000547a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000547e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005482:	0727a823          	sw	s2,112(a5)
}
    80005486:	60e2                	ld	ra,24(sp)
    80005488:	6442                	ld	s0,16(sp)
    8000548a:	64a2                	ld	s1,8(sp)
    8000548c:	6902                	ld	s2,0(sp)
    8000548e:	6105                	addi	sp,sp,32
    80005490:	8082                	ret
    panic("could not find virtio disk");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	27e50513          	addi	a0,a0,638 # 80008710 <syscalls+0x340>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	862080e7          	jalr	-1950(ra) # 80005cfc <panic>
    panic("virtio disk FEATURES_OK unset");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	28e50513          	addi	a0,a0,654 # 80008730 <syscalls+0x360>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	852080e7          	jalr	-1966(ra) # 80005cfc <panic>
    panic("virtio disk should not be ready");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	29e50513          	addi	a0,a0,670 # 80008750 <syscalls+0x380>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	842080e7          	jalr	-1982(ra) # 80005cfc <panic>
    panic("virtio disk has no queue 0");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	2ae50513          	addi	a0,a0,686 # 80008770 <syscalls+0x3a0>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	832080e7          	jalr	-1998(ra) # 80005cfc <panic>
    panic("virtio disk max queue too short");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	2be50513          	addi	a0,a0,702 # 80008790 <syscalls+0x3c0>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	822080e7          	jalr	-2014(ra) # 80005cfc <panic>
    panic("virtio disk kalloc");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	2ce50513          	addi	a0,a0,718 # 800087b0 <syscalls+0x3e0>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	812080e7          	jalr	-2030(ra) # 80005cfc <panic>

00000000800054f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054f2:	7119                	addi	sp,sp,-128
    800054f4:	fc86                	sd	ra,120(sp)
    800054f6:	f8a2                	sd	s0,112(sp)
    800054f8:	f4a6                	sd	s1,104(sp)
    800054fa:	f0ca                	sd	s2,96(sp)
    800054fc:	ecce                	sd	s3,88(sp)
    800054fe:	e8d2                	sd	s4,80(sp)
    80005500:	e4d6                	sd	s5,72(sp)
    80005502:	e0da                	sd	s6,64(sp)
    80005504:	fc5e                	sd	s7,56(sp)
    80005506:	f862                	sd	s8,48(sp)
    80005508:	f466                	sd	s9,40(sp)
    8000550a:	f06a                	sd	s10,32(sp)
    8000550c:	ec6e                	sd	s11,24(sp)
    8000550e:	0100                	addi	s0,sp,128
    80005510:	8aaa                	mv	s5,a0
    80005512:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005514:	00c52d03          	lw	s10,12(a0)
    80005518:	001d1d1b          	slliw	s10,s10,0x1
    8000551c:	1d02                	slli	s10,s10,0x20
    8000551e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005522:	00019517          	auipc	a0,0x19
    80005526:	60650513          	addi	a0,a0,1542 # 8001eb28 <disk+0x128>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	d56080e7          	jalr	-682(ra) # 80006280 <acquire>
  for(int i = 0; i < 3; i++){
    80005532:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005534:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005536:	00019b97          	auipc	s7,0x19
    8000553a:	4cab8b93          	addi	s7,s7,1226 # 8001ea00 <disk>
  for(int i = 0; i < 3; i++){
    8000553e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005540:	00019c97          	auipc	s9,0x19
    80005544:	5e8c8c93          	addi	s9,s9,1512 # 8001eb28 <disk+0x128>
    80005548:	a08d                	j	800055aa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000554a:	00fb8733          	add	a4,s7,a5
    8000554e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005552:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005554:	0207c563          	bltz	a5,8000557e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005558:	2905                	addiw	s2,s2,1
    8000555a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000555c:	05690c63          	beq	s2,s6,800055b4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005560:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005562:	00019717          	auipc	a4,0x19
    80005566:	49e70713          	addi	a4,a4,1182 # 8001ea00 <disk>
    8000556a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000556c:	01874683          	lbu	a3,24(a4)
    80005570:	fee9                	bnez	a3,8000554a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005572:	2785                	addiw	a5,a5,1
    80005574:	0705                	addi	a4,a4,1
    80005576:	fe979be3          	bne	a5,s1,8000556c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000557a:	57fd                	li	a5,-1
    8000557c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000557e:	01205d63          	blez	s2,80005598 <virtio_disk_rw+0xa6>
    80005582:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005584:	000a2503          	lw	a0,0(s4)
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	cfe080e7          	jalr	-770(ra) # 80005286 <free_desc>
      for(int j = 0; j < i; j++)
    80005590:	2d85                	addiw	s11,s11,1
    80005592:	0a11                	addi	s4,s4,4
    80005594:	ff2d98e3          	bne	s11,s2,80005584 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005598:	85e6                	mv	a1,s9
    8000559a:	00019517          	auipc	a0,0x19
    8000559e:	47e50513          	addi	a0,a0,1150 # 8001ea18 <disk+0x18>
    800055a2:	ffffc097          	auipc	ra,0xffffc
    800055a6:	f8c080e7          	jalr	-116(ra) # 8000152e <sleep>
  for(int i = 0; i < 3; i++){
    800055aa:	f8040a13          	addi	s4,s0,-128
{
    800055ae:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055b0:	894e                	mv	s2,s3
    800055b2:	b77d                	j	80005560 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055b4:	f8042503          	lw	a0,-128(s0)
    800055b8:	00a50713          	addi	a4,a0,10
    800055bc:	0712                	slli	a4,a4,0x4

  if(write)
    800055be:	00019797          	auipc	a5,0x19
    800055c2:	44278793          	addi	a5,a5,1090 # 8001ea00 <disk>
    800055c6:	00e786b3          	add	a3,a5,a4
    800055ca:	01803633          	snez	a2,s8
    800055ce:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055d0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800055d4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d8:	f6070613          	addi	a2,a4,-160
    800055dc:	6394                	ld	a3,0(a5)
    800055de:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055e0:	00870593          	addi	a1,a4,8
    800055e4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055e6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055e8:	0007b803          	ld	a6,0(a5)
    800055ec:	9642                	add	a2,a2,a6
    800055ee:	46c1                	li	a3,16
    800055f0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055f2:	4585                	li	a1,1
    800055f4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055f8:	f8442683          	lw	a3,-124(s0)
    800055fc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005600:	0692                	slli	a3,a3,0x4
    80005602:	9836                	add	a6,a6,a3
    80005604:	058a8613          	addi	a2,s5,88
    80005608:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000560c:	0007b803          	ld	a6,0(a5)
    80005610:	96c2                	add	a3,a3,a6
    80005612:	40000613          	li	a2,1024
    80005616:	c690                	sw	a2,8(a3)
  if(write)
    80005618:	001c3613          	seqz	a2,s8
    8000561c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005620:	00166613          	ori	a2,a2,1
    80005624:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005628:	f8842603          	lw	a2,-120(s0)
    8000562c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005630:	00250693          	addi	a3,a0,2
    80005634:	0692                	slli	a3,a3,0x4
    80005636:	96be                	add	a3,a3,a5
    80005638:	58fd                	li	a7,-1
    8000563a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000563e:	0612                	slli	a2,a2,0x4
    80005640:	9832                	add	a6,a6,a2
    80005642:	f9070713          	addi	a4,a4,-112
    80005646:	973e                	add	a4,a4,a5
    80005648:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000564c:	6398                	ld	a4,0(a5)
    8000564e:	9732                	add	a4,a4,a2
    80005650:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005652:	4609                	li	a2,2
    80005654:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005658:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000565c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005660:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005664:	6794                	ld	a3,8(a5)
    80005666:	0026d703          	lhu	a4,2(a3)
    8000566a:	8b1d                	andi	a4,a4,7
    8000566c:	0706                	slli	a4,a4,0x1
    8000566e:	96ba                	add	a3,a3,a4
    80005670:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005674:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005678:	6798                	ld	a4,8(a5)
    8000567a:	00275783          	lhu	a5,2(a4)
    8000567e:	2785                	addiw	a5,a5,1
    80005680:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005684:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005690:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005694:	00019917          	auipc	s2,0x19
    80005698:	49490913          	addi	s2,s2,1172 # 8001eb28 <disk+0x128>
  while(b->disk == 1) {
    8000569c:	4485                	li	s1,1
    8000569e:	00b79c63          	bne	a5,a1,800056b6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800056a2:	85ca                	mv	a1,s2
    800056a4:	8556                	mv	a0,s5
    800056a6:	ffffc097          	auipc	ra,0xffffc
    800056aa:	e88080e7          	jalr	-376(ra) # 8000152e <sleep>
  while(b->disk == 1) {
    800056ae:	004aa783          	lw	a5,4(s5)
    800056b2:	fe9788e3          	beq	a5,s1,800056a2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056b6:	f8042903          	lw	s2,-128(s0)
    800056ba:	00290713          	addi	a4,s2,2
    800056be:	0712                	slli	a4,a4,0x4
    800056c0:	00019797          	auipc	a5,0x19
    800056c4:	34078793          	addi	a5,a5,832 # 8001ea00 <disk>
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056ce:	00019997          	auipc	s3,0x19
    800056d2:	33298993          	addi	s3,s3,818 # 8001ea00 <disk>
    800056d6:	00491713          	slli	a4,s2,0x4
    800056da:	0009b783          	ld	a5,0(s3)
    800056de:	97ba                	add	a5,a5,a4
    800056e0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056e4:	854a                	mv	a0,s2
    800056e6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056ea:	00000097          	auipc	ra,0x0
    800056ee:	b9c080e7          	jalr	-1124(ra) # 80005286 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056f2:	8885                	andi	s1,s1,1
    800056f4:	f0ed                	bnez	s1,800056d6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056f6:	00019517          	auipc	a0,0x19
    800056fa:	43250513          	addi	a0,a0,1074 # 8001eb28 <disk+0x128>
    800056fe:	00001097          	auipc	ra,0x1
    80005702:	c36080e7          	jalr	-970(ra) # 80006334 <release>
}
    80005706:	70e6                	ld	ra,120(sp)
    80005708:	7446                	ld	s0,112(sp)
    8000570a:	74a6                	ld	s1,104(sp)
    8000570c:	7906                	ld	s2,96(sp)
    8000570e:	69e6                	ld	s3,88(sp)
    80005710:	6a46                	ld	s4,80(sp)
    80005712:	6aa6                	ld	s5,72(sp)
    80005714:	6b06                	ld	s6,64(sp)
    80005716:	7be2                	ld	s7,56(sp)
    80005718:	7c42                	ld	s8,48(sp)
    8000571a:	7ca2                	ld	s9,40(sp)
    8000571c:	7d02                	ld	s10,32(sp)
    8000571e:	6de2                	ld	s11,24(sp)
    80005720:	6109                	addi	sp,sp,128
    80005722:	8082                	ret

0000000080005724 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005724:	1101                	addi	sp,sp,-32
    80005726:	ec06                	sd	ra,24(sp)
    80005728:	e822                	sd	s0,16(sp)
    8000572a:	e426                	sd	s1,8(sp)
    8000572c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000572e:	00019497          	auipc	s1,0x19
    80005732:	2d248493          	addi	s1,s1,722 # 8001ea00 <disk>
    80005736:	00019517          	auipc	a0,0x19
    8000573a:	3f250513          	addi	a0,a0,1010 # 8001eb28 <disk+0x128>
    8000573e:	00001097          	auipc	ra,0x1
    80005742:	b42080e7          	jalr	-1214(ra) # 80006280 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005746:	10001737          	lui	a4,0x10001
    8000574a:	533c                	lw	a5,96(a4)
    8000574c:	8b8d                	andi	a5,a5,3
    8000574e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005750:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005754:	689c                	ld	a5,16(s1)
    80005756:	0204d703          	lhu	a4,32(s1)
    8000575a:	0027d783          	lhu	a5,2(a5)
    8000575e:	04f70863          	beq	a4,a5,800057ae <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005762:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005766:	6898                	ld	a4,16(s1)
    80005768:	0204d783          	lhu	a5,32(s1)
    8000576c:	8b9d                	andi	a5,a5,7
    8000576e:	078e                	slli	a5,a5,0x3
    80005770:	97ba                	add	a5,a5,a4
    80005772:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005774:	00278713          	addi	a4,a5,2
    80005778:	0712                	slli	a4,a4,0x4
    8000577a:	9726                	add	a4,a4,s1
    8000577c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005780:	e721                	bnez	a4,800057c8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005782:	0789                	addi	a5,a5,2
    80005784:	0792                	slli	a5,a5,0x4
    80005786:	97a6                	add	a5,a5,s1
    80005788:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000578a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000578e:	ffffc097          	auipc	ra,0xffffc
    80005792:	e04080e7          	jalr	-508(ra) # 80001592 <wakeup>

    disk.used_idx += 1;
    80005796:	0204d783          	lhu	a5,32(s1)
    8000579a:	2785                	addiw	a5,a5,1
    8000579c:	17c2                	slli	a5,a5,0x30
    8000579e:	93c1                	srli	a5,a5,0x30
    800057a0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057a4:	6898                	ld	a4,16(s1)
    800057a6:	00275703          	lhu	a4,2(a4)
    800057aa:	faf71ce3          	bne	a4,a5,80005762 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057ae:	00019517          	auipc	a0,0x19
    800057b2:	37a50513          	addi	a0,a0,890 # 8001eb28 <disk+0x128>
    800057b6:	00001097          	auipc	ra,0x1
    800057ba:	b7e080e7          	jalr	-1154(ra) # 80006334 <release>
}
    800057be:	60e2                	ld	ra,24(sp)
    800057c0:	6442                	ld	s0,16(sp)
    800057c2:	64a2                	ld	s1,8(sp)
    800057c4:	6105                	addi	sp,sp,32
    800057c6:	8082                	ret
      panic("virtio_disk_intr status");
    800057c8:	00003517          	auipc	a0,0x3
    800057cc:	00050513          	mv	a0,a0
    800057d0:	00000097          	auipc	ra,0x0
    800057d4:	52c080e7          	jalr	1324(ra) # 80005cfc <panic>

00000000800057d8 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057d8:	1141                	addi	sp,sp,-16
    800057da:	e422                	sd	s0,8(sp)
    800057dc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057de:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057e2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057e6:	0037979b          	slliw	a5,a5,0x3
    800057ea:	02004737          	lui	a4,0x2004
    800057ee:	97ba                	add	a5,a5,a4
    800057f0:	0200c737          	lui	a4,0x200c
    800057f4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057f8:	000f4637          	lui	a2,0xf4
    800057fc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005800:	9732                	add	a4,a4,a2
    80005802:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005804:	00259693          	slli	a3,a1,0x2
    80005808:	96ae                	add	a3,a3,a1
    8000580a:	068e                	slli	a3,a3,0x3
    8000580c:	00019717          	auipc	a4,0x19
    80005810:	33470713          	addi	a4,a4,820 # 8001eb40 <timer_scratch>
    80005814:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005816:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005818:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000581a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000581e:	00000797          	auipc	a5,0x0
    80005822:	9a278793          	addi	a5,a5,-1630 # 800051c0 <timervec>
    80005826:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000582a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000582e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005832:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005836:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000583a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000583e:	30479073          	csrw	mie,a5
}
    80005842:	6422                	ld	s0,8(sp)
    80005844:	0141                	addi	sp,sp,16
    80005846:	8082                	ret

0000000080005848 <start>:
{
    80005848:	1141                	addi	sp,sp,-16
    8000584a:	e406                	sd	ra,8(sp)
    8000584c:	e022                	sd	s0,0(sp)
    8000584e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005850:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005854:	7779                	lui	a4,0xffffe
    80005856:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd7a7f>
    8000585a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000585c:	6705                	lui	a4,0x1
    8000585e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005862:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005864:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005868:	ffffb797          	auipc	a5,0xffffb
    8000586c:	ab878793          	addi	a5,a5,-1352 # 80000320 <main>
    80005870:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005874:	4781                	li	a5,0
    80005876:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000587a:	67c1                	lui	a5,0x10
    8000587c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000587e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005882:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005886:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000588a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000588e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005892:	57fd                	li	a5,-1
    80005894:	83a9                	srli	a5,a5,0xa
    80005896:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000589a:	47bd                	li	a5,15
    8000589c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058a0:	00000097          	auipc	ra,0x0
    800058a4:	f38080e7          	jalr	-200(ra) # 800057d8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058a8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058ac:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058ae:	823e                	mv	tp,a5
  asm volatile("mret");
    800058b0:	30200073          	mret
}
    800058b4:	60a2                	ld	ra,8(sp)
    800058b6:	6402                	ld	s0,0(sp)
    800058b8:	0141                	addi	sp,sp,16
    800058ba:	8082                	ret

00000000800058bc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058bc:	715d                	addi	sp,sp,-80
    800058be:	e486                	sd	ra,72(sp)
    800058c0:	e0a2                	sd	s0,64(sp)
    800058c2:	fc26                	sd	s1,56(sp)
    800058c4:	f84a                	sd	s2,48(sp)
    800058c6:	f44e                	sd	s3,40(sp)
    800058c8:	f052                	sd	s4,32(sp)
    800058ca:	ec56                	sd	s5,24(sp)
    800058cc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058ce:	04c05763          	blez	a2,8000591c <consolewrite+0x60>
    800058d2:	8a2a                	mv	s4,a0
    800058d4:	84ae                	mv	s1,a1
    800058d6:	89b2                	mv	s3,a2
    800058d8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058da:	5afd                	li	s5,-1
    800058dc:	4685                	li	a3,1
    800058de:	8626                	mv	a2,s1
    800058e0:	85d2                	mv	a1,s4
    800058e2:	fbf40513          	addi	a0,s0,-65
    800058e6:	ffffc097          	auipc	ra,0xffffc
    800058ea:	0ae080e7          	jalr	174(ra) # 80001994 <either_copyin>
    800058ee:	01550d63          	beq	a0,s5,80005908 <consolewrite+0x4c>
      break;
    uartputc(c);
    800058f2:	fbf44503          	lbu	a0,-65(s0)
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	7d0080e7          	jalr	2000(ra) # 800060c6 <uartputc>
  for(i = 0; i < n; i++){
    800058fe:	2905                	addiw	s2,s2,1
    80005900:	0485                	addi	s1,s1,1
    80005902:	fd299de3          	bne	s3,s2,800058dc <consolewrite+0x20>
    80005906:	894e                	mv	s2,s3
  }

  return i;
}
    80005908:	854a                	mv	a0,s2
    8000590a:	60a6                	ld	ra,72(sp)
    8000590c:	6406                	ld	s0,64(sp)
    8000590e:	74e2                	ld	s1,56(sp)
    80005910:	7942                	ld	s2,48(sp)
    80005912:	79a2                	ld	s3,40(sp)
    80005914:	7a02                	ld	s4,32(sp)
    80005916:	6ae2                	ld	s5,24(sp)
    80005918:	6161                	addi	sp,sp,80
    8000591a:	8082                	ret
  for(i = 0; i < n; i++){
    8000591c:	4901                	li	s2,0
    8000591e:	b7ed                	j	80005908 <consolewrite+0x4c>

0000000080005920 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005920:	7159                	addi	sp,sp,-112
    80005922:	f486                	sd	ra,104(sp)
    80005924:	f0a2                	sd	s0,96(sp)
    80005926:	eca6                	sd	s1,88(sp)
    80005928:	e8ca                	sd	s2,80(sp)
    8000592a:	e4ce                	sd	s3,72(sp)
    8000592c:	e0d2                	sd	s4,64(sp)
    8000592e:	fc56                	sd	s5,56(sp)
    80005930:	f85a                	sd	s6,48(sp)
    80005932:	f45e                	sd	s7,40(sp)
    80005934:	f062                	sd	s8,32(sp)
    80005936:	ec66                	sd	s9,24(sp)
    80005938:	e86a                	sd	s10,16(sp)
    8000593a:	1880                	addi	s0,sp,112
    8000593c:	8aaa                	mv	s5,a0
    8000593e:	8a2e                	mv	s4,a1
    80005940:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005942:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005946:	00021517          	auipc	a0,0x21
    8000594a:	33a50513          	addi	a0,a0,826 # 80026c80 <cons>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	932080e7          	jalr	-1742(ra) # 80006280 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005956:	00021497          	auipc	s1,0x21
    8000595a:	32a48493          	addi	s1,s1,810 # 80026c80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000595e:	00021917          	auipc	s2,0x21
    80005962:	3ba90913          	addi	s2,s2,954 # 80026d18 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005966:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005968:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000596a:	4ca9                	li	s9,10
  while(n > 0){
    8000596c:	07305b63          	blez	s3,800059e2 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005970:	0984a783          	lw	a5,152(s1)
    80005974:	09c4a703          	lw	a4,156(s1)
    80005978:	02f71763          	bne	a4,a5,800059a6 <consoleread+0x86>
      if(killed(myproc())){
    8000597c:	ffffb097          	auipc	ra,0xffffb
    80005980:	4d6080e7          	jalr	1238(ra) # 80000e52 <myproc>
    80005984:	ffffc097          	auipc	ra,0xffffc
    80005988:	e56080e7          	jalr	-426(ra) # 800017da <killed>
    8000598c:	e535                	bnez	a0,800059f8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000598e:	85a6                	mv	a1,s1
    80005990:	854a                	mv	a0,s2
    80005992:	ffffc097          	auipc	ra,0xffffc
    80005996:	b9c080e7          	jalr	-1124(ra) # 8000152e <sleep>
    while(cons.r == cons.w){
    8000599a:	0984a783          	lw	a5,152(s1)
    8000599e:	09c4a703          	lw	a4,156(s1)
    800059a2:	fcf70de3          	beq	a4,a5,8000597c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059a6:	0017871b          	addiw	a4,a5,1
    800059aa:	08e4ac23          	sw	a4,152(s1)
    800059ae:	07f7f713          	andi	a4,a5,127
    800059b2:	9726                	add	a4,a4,s1
    800059b4:	01874703          	lbu	a4,24(a4)
    800059b8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800059bc:	077d0563          	beq	s10,s7,80005a26 <consoleread+0x106>
    cbuf = c;
    800059c0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059c4:	4685                	li	a3,1
    800059c6:	f9f40613          	addi	a2,s0,-97
    800059ca:	85d2                	mv	a1,s4
    800059cc:	8556                	mv	a0,s5
    800059ce:	ffffc097          	auipc	ra,0xffffc
    800059d2:	f6e080e7          	jalr	-146(ra) # 8000193c <either_copyout>
    800059d6:	01850663          	beq	a0,s8,800059e2 <consoleread+0xc2>
    dst++;
    800059da:	0a05                	addi	s4,s4,1
    --n;
    800059dc:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800059de:	f99d17e3          	bne	s10,s9,8000596c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059e2:	00021517          	auipc	a0,0x21
    800059e6:	29e50513          	addi	a0,a0,670 # 80026c80 <cons>
    800059ea:	00001097          	auipc	ra,0x1
    800059ee:	94a080e7          	jalr	-1718(ra) # 80006334 <release>

  return target - n;
    800059f2:	413b053b          	subw	a0,s6,s3
    800059f6:	a811                	j	80005a0a <consoleread+0xea>
        release(&cons.lock);
    800059f8:	00021517          	auipc	a0,0x21
    800059fc:	28850513          	addi	a0,a0,648 # 80026c80 <cons>
    80005a00:	00001097          	auipc	ra,0x1
    80005a04:	934080e7          	jalr	-1740(ra) # 80006334 <release>
        return -1;
    80005a08:	557d                	li	a0,-1
}
    80005a0a:	70a6                	ld	ra,104(sp)
    80005a0c:	7406                	ld	s0,96(sp)
    80005a0e:	64e6                	ld	s1,88(sp)
    80005a10:	6946                	ld	s2,80(sp)
    80005a12:	69a6                	ld	s3,72(sp)
    80005a14:	6a06                	ld	s4,64(sp)
    80005a16:	7ae2                	ld	s5,56(sp)
    80005a18:	7b42                	ld	s6,48(sp)
    80005a1a:	7ba2                	ld	s7,40(sp)
    80005a1c:	7c02                	ld	s8,32(sp)
    80005a1e:	6ce2                	ld	s9,24(sp)
    80005a20:	6d42                	ld	s10,16(sp)
    80005a22:	6165                	addi	sp,sp,112
    80005a24:	8082                	ret
      if(n < target){
    80005a26:	0009871b          	sext.w	a4,s3
    80005a2a:	fb677ce3          	bgeu	a4,s6,800059e2 <consoleread+0xc2>
        cons.r--;
    80005a2e:	00021717          	auipc	a4,0x21
    80005a32:	2ef72523          	sw	a5,746(a4) # 80026d18 <cons+0x98>
    80005a36:	b775                	j	800059e2 <consoleread+0xc2>

0000000080005a38 <consputc>:
{
    80005a38:	1141                	addi	sp,sp,-16
    80005a3a:	e406                	sd	ra,8(sp)
    80005a3c:	e022                	sd	s0,0(sp)
    80005a3e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a40:	10000793          	li	a5,256
    80005a44:	00f50a63          	beq	a0,a5,80005a58 <consputc+0x20>
    uartputc_sync(c);
    80005a48:	00000097          	auipc	ra,0x0
    80005a4c:	5ac080e7          	jalr	1452(ra) # 80005ff4 <uartputc_sync>
}
    80005a50:	60a2                	ld	ra,8(sp)
    80005a52:	6402                	ld	s0,0(sp)
    80005a54:	0141                	addi	sp,sp,16
    80005a56:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a58:	4521                	li	a0,8
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	59a080e7          	jalr	1434(ra) # 80005ff4 <uartputc_sync>
    80005a62:	02000513          	li	a0,32
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	58e080e7          	jalr	1422(ra) # 80005ff4 <uartputc_sync>
    80005a6e:	4521                	li	a0,8
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	584080e7          	jalr	1412(ra) # 80005ff4 <uartputc_sync>
    80005a78:	bfe1                	j	80005a50 <consputc+0x18>

0000000080005a7a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a7a:	1101                	addi	sp,sp,-32
    80005a7c:	ec06                	sd	ra,24(sp)
    80005a7e:	e822                	sd	s0,16(sp)
    80005a80:	e426                	sd	s1,8(sp)
    80005a82:	e04a                	sd	s2,0(sp)
    80005a84:	1000                	addi	s0,sp,32
    80005a86:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a88:	00021517          	auipc	a0,0x21
    80005a8c:	1f850513          	addi	a0,a0,504 # 80026c80 <cons>
    80005a90:	00000097          	auipc	ra,0x0
    80005a94:	7f0080e7          	jalr	2032(ra) # 80006280 <acquire>

  switch(c){
    80005a98:	47d5                	li	a5,21
    80005a9a:	0af48663          	beq	s1,a5,80005b46 <consoleintr+0xcc>
    80005a9e:	0297ca63          	blt	a5,s1,80005ad2 <consoleintr+0x58>
    80005aa2:	47a1                	li	a5,8
    80005aa4:	0ef48763          	beq	s1,a5,80005b92 <consoleintr+0x118>
    80005aa8:	47c1                	li	a5,16
    80005aaa:	10f49a63          	bne	s1,a5,80005bbe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005aae:	ffffc097          	auipc	ra,0xffffc
    80005ab2:	f3e080e7          	jalr	-194(ra) # 800019ec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ab6:	00021517          	auipc	a0,0x21
    80005aba:	1ca50513          	addi	a0,a0,458 # 80026c80 <cons>
    80005abe:	00001097          	auipc	ra,0x1
    80005ac2:	876080e7          	jalr	-1930(ra) # 80006334 <release>
}
    80005ac6:	60e2                	ld	ra,24(sp)
    80005ac8:	6442                	ld	s0,16(sp)
    80005aca:	64a2                	ld	s1,8(sp)
    80005acc:	6902                	ld	s2,0(sp)
    80005ace:	6105                	addi	sp,sp,32
    80005ad0:	8082                	ret
  switch(c){
    80005ad2:	07f00793          	li	a5,127
    80005ad6:	0af48e63          	beq	s1,a5,80005b92 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ada:	00021717          	auipc	a4,0x21
    80005ade:	1a670713          	addi	a4,a4,422 # 80026c80 <cons>
    80005ae2:	0a072783          	lw	a5,160(a4)
    80005ae6:	09872703          	lw	a4,152(a4)
    80005aea:	9f99                	subw	a5,a5,a4
    80005aec:	07f00713          	li	a4,127
    80005af0:	fcf763e3          	bltu	a4,a5,80005ab6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005af4:	47b5                	li	a5,13
    80005af6:	0cf48763          	beq	s1,a5,80005bc4 <consoleintr+0x14a>
      consputc(c);
    80005afa:	8526                	mv	a0,s1
    80005afc:	00000097          	auipc	ra,0x0
    80005b00:	f3c080e7          	jalr	-196(ra) # 80005a38 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b04:	00021797          	auipc	a5,0x21
    80005b08:	17c78793          	addi	a5,a5,380 # 80026c80 <cons>
    80005b0c:	0a07a683          	lw	a3,160(a5)
    80005b10:	0016871b          	addiw	a4,a3,1
    80005b14:	0007061b          	sext.w	a2,a4
    80005b18:	0ae7a023          	sw	a4,160(a5)
    80005b1c:	07f6f693          	andi	a3,a3,127
    80005b20:	97b6                	add	a5,a5,a3
    80005b22:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b26:	47a9                	li	a5,10
    80005b28:	0cf48563          	beq	s1,a5,80005bf2 <consoleintr+0x178>
    80005b2c:	4791                	li	a5,4
    80005b2e:	0cf48263          	beq	s1,a5,80005bf2 <consoleintr+0x178>
    80005b32:	00021797          	auipc	a5,0x21
    80005b36:	1e67a783          	lw	a5,486(a5) # 80026d18 <cons+0x98>
    80005b3a:	9f1d                	subw	a4,a4,a5
    80005b3c:	08000793          	li	a5,128
    80005b40:	f6f71be3          	bne	a4,a5,80005ab6 <consoleintr+0x3c>
    80005b44:	a07d                	j	80005bf2 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b46:	00021717          	auipc	a4,0x21
    80005b4a:	13a70713          	addi	a4,a4,314 # 80026c80 <cons>
    80005b4e:	0a072783          	lw	a5,160(a4)
    80005b52:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b56:	00021497          	auipc	s1,0x21
    80005b5a:	12a48493          	addi	s1,s1,298 # 80026c80 <cons>
    while(cons.e != cons.w &&
    80005b5e:	4929                	li	s2,10
    80005b60:	f4f70be3          	beq	a4,a5,80005ab6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b64:	37fd                	addiw	a5,a5,-1
    80005b66:	07f7f713          	andi	a4,a5,127
    80005b6a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b6c:	01874703          	lbu	a4,24(a4)
    80005b70:	f52703e3          	beq	a4,s2,80005ab6 <consoleintr+0x3c>
      cons.e--;
    80005b74:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b78:	10000513          	li	a0,256
    80005b7c:	00000097          	auipc	ra,0x0
    80005b80:	ebc080e7          	jalr	-324(ra) # 80005a38 <consputc>
    while(cons.e != cons.w &&
    80005b84:	0a04a783          	lw	a5,160(s1)
    80005b88:	09c4a703          	lw	a4,156(s1)
    80005b8c:	fcf71ce3          	bne	a4,a5,80005b64 <consoleintr+0xea>
    80005b90:	b71d                	j	80005ab6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b92:	00021717          	auipc	a4,0x21
    80005b96:	0ee70713          	addi	a4,a4,238 # 80026c80 <cons>
    80005b9a:	0a072783          	lw	a5,160(a4)
    80005b9e:	09c72703          	lw	a4,156(a4)
    80005ba2:	f0f70ae3          	beq	a4,a5,80005ab6 <consoleintr+0x3c>
      cons.e--;
    80005ba6:	37fd                	addiw	a5,a5,-1
    80005ba8:	00021717          	auipc	a4,0x21
    80005bac:	16f72c23          	sw	a5,376(a4) # 80026d20 <cons+0xa0>
      consputc(BACKSPACE);
    80005bb0:	10000513          	li	a0,256
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	e84080e7          	jalr	-380(ra) # 80005a38 <consputc>
    80005bbc:	bded                	j	80005ab6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bbe:	ee048ce3          	beqz	s1,80005ab6 <consoleintr+0x3c>
    80005bc2:	bf21                	j	80005ada <consoleintr+0x60>
      consputc(c);
    80005bc4:	4529                	li	a0,10
    80005bc6:	00000097          	auipc	ra,0x0
    80005bca:	e72080e7          	jalr	-398(ra) # 80005a38 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bce:	00021797          	auipc	a5,0x21
    80005bd2:	0b278793          	addi	a5,a5,178 # 80026c80 <cons>
    80005bd6:	0a07a703          	lw	a4,160(a5)
    80005bda:	0017069b          	addiw	a3,a4,1
    80005bde:	0006861b          	sext.w	a2,a3
    80005be2:	0ad7a023          	sw	a3,160(a5)
    80005be6:	07f77713          	andi	a4,a4,127
    80005bea:	97ba                	add	a5,a5,a4
    80005bec:	4729                	li	a4,10
    80005bee:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bf2:	00021797          	auipc	a5,0x21
    80005bf6:	12c7a523          	sw	a2,298(a5) # 80026d1c <cons+0x9c>
        wakeup(&cons.r);
    80005bfa:	00021517          	auipc	a0,0x21
    80005bfe:	11e50513          	addi	a0,a0,286 # 80026d18 <cons+0x98>
    80005c02:	ffffc097          	auipc	ra,0xffffc
    80005c06:	990080e7          	jalr	-1648(ra) # 80001592 <wakeup>
    80005c0a:	b575                	j	80005ab6 <consoleintr+0x3c>

0000000080005c0c <consoleinit>:

void
consoleinit(void)
{
    80005c0c:	1141                	addi	sp,sp,-16
    80005c0e:	e406                	sd	ra,8(sp)
    80005c10:	e022                	sd	s0,0(sp)
    80005c12:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c14:	00003597          	auipc	a1,0x3
    80005c18:	bcc58593          	addi	a1,a1,-1076 # 800087e0 <syscalls+0x410>
    80005c1c:	00021517          	auipc	a0,0x21
    80005c20:	06450513          	addi	a0,a0,100 # 80026c80 <cons>
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	5cc080e7          	jalr	1484(ra) # 800061f0 <initlock>

  uartinit();
    80005c2c:	00000097          	auipc	ra,0x0
    80005c30:	378080e7          	jalr	888(ra) # 80005fa4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c34:	00018797          	auipc	a5,0x18
    80005c38:	d7478793          	addi	a5,a5,-652 # 8001d9a8 <devsw>
    80005c3c:	00000717          	auipc	a4,0x0
    80005c40:	ce470713          	addi	a4,a4,-796 # 80005920 <consoleread>
    80005c44:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c46:	00000717          	auipc	a4,0x0
    80005c4a:	c7670713          	addi	a4,a4,-906 # 800058bc <consolewrite>
    80005c4e:	ef98                	sd	a4,24(a5)
}
    80005c50:	60a2                	ld	ra,8(sp)
    80005c52:	6402                	ld	s0,0(sp)
    80005c54:	0141                	addi	sp,sp,16
    80005c56:	8082                	ret

0000000080005c58 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c58:	7179                	addi	sp,sp,-48
    80005c5a:	f406                	sd	ra,40(sp)
    80005c5c:	f022                	sd	s0,32(sp)
    80005c5e:	ec26                	sd	s1,24(sp)
    80005c60:	e84a                	sd	s2,16(sp)
    80005c62:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c64:	c219                	beqz	a2,80005c6a <printint+0x12>
    80005c66:	08054763          	bltz	a0,80005cf4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c6a:	2501                	sext.w	a0,a0
    80005c6c:	4881                	li	a7,0
    80005c6e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c72:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c74:	2581                	sext.w	a1,a1
    80005c76:	00003617          	auipc	a2,0x3
    80005c7a:	baa60613          	addi	a2,a2,-1110 # 80008820 <digits>
    80005c7e:	883a                	mv	a6,a4
    80005c80:	2705                	addiw	a4,a4,1
    80005c82:	02b577bb          	remuw	a5,a0,a1
    80005c86:	1782                	slli	a5,a5,0x20
    80005c88:	9381                	srli	a5,a5,0x20
    80005c8a:	97b2                	add	a5,a5,a2
    80005c8c:	0007c783          	lbu	a5,0(a5)
    80005c90:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c94:	0005079b          	sext.w	a5,a0
    80005c98:	02b5553b          	divuw	a0,a0,a1
    80005c9c:	0685                	addi	a3,a3,1
    80005c9e:	feb7f0e3          	bgeu	a5,a1,80005c7e <printint+0x26>

  if(sign)
    80005ca2:	00088c63          	beqz	a7,80005cba <printint+0x62>
    buf[i++] = '-';
    80005ca6:	fe070793          	addi	a5,a4,-32
    80005caa:	00878733          	add	a4,a5,s0
    80005cae:	02d00793          	li	a5,45
    80005cb2:	fef70823          	sb	a5,-16(a4)
    80005cb6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cba:	02e05763          	blez	a4,80005ce8 <printint+0x90>
    80005cbe:	fd040793          	addi	a5,s0,-48
    80005cc2:	00e784b3          	add	s1,a5,a4
    80005cc6:	fff78913          	addi	s2,a5,-1
    80005cca:	993a                	add	s2,s2,a4
    80005ccc:	377d                	addiw	a4,a4,-1
    80005cce:	1702                	slli	a4,a4,0x20
    80005cd0:	9301                	srli	a4,a4,0x20
    80005cd2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cd6:	fff4c503          	lbu	a0,-1(s1)
    80005cda:	00000097          	auipc	ra,0x0
    80005cde:	d5e080e7          	jalr	-674(ra) # 80005a38 <consputc>
  while(--i >= 0)
    80005ce2:	14fd                	addi	s1,s1,-1
    80005ce4:	ff2499e3          	bne	s1,s2,80005cd6 <printint+0x7e>
}
    80005ce8:	70a2                	ld	ra,40(sp)
    80005cea:	7402                	ld	s0,32(sp)
    80005cec:	64e2                	ld	s1,24(sp)
    80005cee:	6942                	ld	s2,16(sp)
    80005cf0:	6145                	addi	sp,sp,48
    80005cf2:	8082                	ret
    x = -xx;
    80005cf4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cf8:	4885                	li	a7,1
    x = -xx;
    80005cfa:	bf95                	j	80005c6e <printint+0x16>

0000000080005cfc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cfc:	1101                	addi	sp,sp,-32
    80005cfe:	ec06                	sd	ra,24(sp)
    80005d00:	e822                	sd	s0,16(sp)
    80005d02:	e426                	sd	s1,8(sp)
    80005d04:	1000                	addi	s0,sp,32
    80005d06:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d08:	00021797          	auipc	a5,0x21
    80005d0c:	0207ac23          	sw	zero,56(a5) # 80026d40 <pr+0x18>
  printf("panic: ");
    80005d10:	00003517          	auipc	a0,0x3
    80005d14:	ad850513          	addi	a0,a0,-1320 # 800087e8 <syscalls+0x418>
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	02e080e7          	jalr	46(ra) # 80005d46 <printf>
  printf(s);
    80005d20:	8526                	mv	a0,s1
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	024080e7          	jalr	36(ra) # 80005d46 <printf>
  printf("\n");
    80005d2a:	00002517          	auipc	a0,0x2
    80005d2e:	31e50513          	addi	a0,a0,798 # 80008048 <etext+0x48>
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	014080e7          	jalr	20(ra) # 80005d46 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d3a:	4785                	li	a5,1
    80005d3c:	00003717          	auipc	a4,0x3
    80005d40:	bcf72023          	sw	a5,-1088(a4) # 800088fc <panicked>
  for(;;)
    80005d44:	a001                	j	80005d44 <panic+0x48>

0000000080005d46 <printf>:
{
    80005d46:	7131                	addi	sp,sp,-192
    80005d48:	fc86                	sd	ra,120(sp)
    80005d4a:	f8a2                	sd	s0,112(sp)
    80005d4c:	f4a6                	sd	s1,104(sp)
    80005d4e:	f0ca                	sd	s2,96(sp)
    80005d50:	ecce                	sd	s3,88(sp)
    80005d52:	e8d2                	sd	s4,80(sp)
    80005d54:	e4d6                	sd	s5,72(sp)
    80005d56:	e0da                	sd	s6,64(sp)
    80005d58:	fc5e                	sd	s7,56(sp)
    80005d5a:	f862                	sd	s8,48(sp)
    80005d5c:	f466                	sd	s9,40(sp)
    80005d5e:	f06a                	sd	s10,32(sp)
    80005d60:	ec6e                	sd	s11,24(sp)
    80005d62:	0100                	addi	s0,sp,128
    80005d64:	8a2a                	mv	s4,a0
    80005d66:	e40c                	sd	a1,8(s0)
    80005d68:	e810                	sd	a2,16(s0)
    80005d6a:	ec14                	sd	a3,24(s0)
    80005d6c:	f018                	sd	a4,32(s0)
    80005d6e:	f41c                	sd	a5,40(s0)
    80005d70:	03043823          	sd	a6,48(s0)
    80005d74:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d78:	00021d97          	auipc	s11,0x21
    80005d7c:	fc8dad83          	lw	s11,-56(s11) # 80026d40 <pr+0x18>
  if(locking)
    80005d80:	020d9b63          	bnez	s11,80005db6 <printf+0x70>
  if (fmt == 0)
    80005d84:	040a0263          	beqz	s4,80005dc8 <printf+0x82>
  va_start(ap, fmt);
    80005d88:	00840793          	addi	a5,s0,8
    80005d8c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d90:	000a4503          	lbu	a0,0(s4)
    80005d94:	14050f63          	beqz	a0,80005ef2 <printf+0x1ac>
    80005d98:	4981                	li	s3,0
    if(c != '%'){
    80005d9a:	02500a93          	li	s5,37
    switch(c){
    80005d9e:	07000b93          	li	s7,112
  consputc('x');
    80005da2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005da4:	00003b17          	auipc	s6,0x3
    80005da8:	a7cb0b13          	addi	s6,s6,-1412 # 80008820 <digits>
    switch(c){
    80005dac:	07300c93          	li	s9,115
    80005db0:	06400c13          	li	s8,100
    80005db4:	a82d                	j	80005dee <printf+0xa8>
    acquire(&pr.lock);
    80005db6:	00021517          	auipc	a0,0x21
    80005dba:	f7250513          	addi	a0,a0,-142 # 80026d28 <pr>
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	4c2080e7          	jalr	1218(ra) # 80006280 <acquire>
    80005dc6:	bf7d                	j	80005d84 <printf+0x3e>
    panic("null fmt");
    80005dc8:	00003517          	auipc	a0,0x3
    80005dcc:	a3050513          	addi	a0,a0,-1488 # 800087f8 <syscalls+0x428>
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	f2c080e7          	jalr	-212(ra) # 80005cfc <panic>
      consputc(c);
    80005dd8:	00000097          	auipc	ra,0x0
    80005ddc:	c60080e7          	jalr	-928(ra) # 80005a38 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005de0:	2985                	addiw	s3,s3,1
    80005de2:	013a07b3          	add	a5,s4,s3
    80005de6:	0007c503          	lbu	a0,0(a5)
    80005dea:	10050463          	beqz	a0,80005ef2 <printf+0x1ac>
    if(c != '%'){
    80005dee:	ff5515e3          	bne	a0,s5,80005dd8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005df2:	2985                	addiw	s3,s3,1
    80005df4:	013a07b3          	add	a5,s4,s3
    80005df8:	0007c783          	lbu	a5,0(a5)
    80005dfc:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e00:	cbed                	beqz	a5,80005ef2 <printf+0x1ac>
    switch(c){
    80005e02:	05778a63          	beq	a5,s7,80005e56 <printf+0x110>
    80005e06:	02fbf663          	bgeu	s7,a5,80005e32 <printf+0xec>
    80005e0a:	09978863          	beq	a5,s9,80005e9a <printf+0x154>
    80005e0e:	07800713          	li	a4,120
    80005e12:	0ce79563          	bne	a5,a4,80005edc <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e16:	f8843783          	ld	a5,-120(s0)
    80005e1a:	00878713          	addi	a4,a5,8
    80005e1e:	f8e43423          	sd	a4,-120(s0)
    80005e22:	4605                	li	a2,1
    80005e24:	85ea                	mv	a1,s10
    80005e26:	4388                	lw	a0,0(a5)
    80005e28:	00000097          	auipc	ra,0x0
    80005e2c:	e30080e7          	jalr	-464(ra) # 80005c58 <printint>
      break;
    80005e30:	bf45                	j	80005de0 <printf+0x9a>
    switch(c){
    80005e32:	09578f63          	beq	a5,s5,80005ed0 <printf+0x18a>
    80005e36:	0b879363          	bne	a5,s8,80005edc <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e3a:	f8843783          	ld	a5,-120(s0)
    80005e3e:	00878713          	addi	a4,a5,8
    80005e42:	f8e43423          	sd	a4,-120(s0)
    80005e46:	4605                	li	a2,1
    80005e48:	45a9                	li	a1,10
    80005e4a:	4388                	lw	a0,0(a5)
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	e0c080e7          	jalr	-500(ra) # 80005c58 <printint>
      break;
    80005e54:	b771                	j	80005de0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e56:	f8843783          	ld	a5,-120(s0)
    80005e5a:	00878713          	addi	a4,a5,8
    80005e5e:	f8e43423          	sd	a4,-120(s0)
    80005e62:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e66:	03000513          	li	a0,48
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	bce080e7          	jalr	-1074(ra) # 80005a38 <consputc>
  consputc('x');
    80005e72:	07800513          	li	a0,120
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	bc2080e7          	jalr	-1086(ra) # 80005a38 <consputc>
    80005e7e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e80:	03c95793          	srli	a5,s2,0x3c
    80005e84:	97da                	add	a5,a5,s6
    80005e86:	0007c503          	lbu	a0,0(a5)
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	bae080e7          	jalr	-1106(ra) # 80005a38 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e92:	0912                	slli	s2,s2,0x4
    80005e94:	34fd                	addiw	s1,s1,-1
    80005e96:	f4ed                	bnez	s1,80005e80 <printf+0x13a>
    80005e98:	b7a1                	j	80005de0 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e9a:	f8843783          	ld	a5,-120(s0)
    80005e9e:	00878713          	addi	a4,a5,8
    80005ea2:	f8e43423          	sd	a4,-120(s0)
    80005ea6:	6384                	ld	s1,0(a5)
    80005ea8:	cc89                	beqz	s1,80005ec2 <printf+0x17c>
      for(; *s; s++)
    80005eaa:	0004c503          	lbu	a0,0(s1)
    80005eae:	d90d                	beqz	a0,80005de0 <printf+0x9a>
        consputc(*s);
    80005eb0:	00000097          	auipc	ra,0x0
    80005eb4:	b88080e7          	jalr	-1144(ra) # 80005a38 <consputc>
      for(; *s; s++)
    80005eb8:	0485                	addi	s1,s1,1
    80005eba:	0004c503          	lbu	a0,0(s1)
    80005ebe:	f96d                	bnez	a0,80005eb0 <printf+0x16a>
    80005ec0:	b705                	j	80005de0 <printf+0x9a>
        s = "(null)";
    80005ec2:	00003497          	auipc	s1,0x3
    80005ec6:	92e48493          	addi	s1,s1,-1746 # 800087f0 <syscalls+0x420>
      for(; *s; s++)
    80005eca:	02800513          	li	a0,40
    80005ece:	b7cd                	j	80005eb0 <printf+0x16a>
      consputc('%');
    80005ed0:	8556                	mv	a0,s5
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	b66080e7          	jalr	-1178(ra) # 80005a38 <consputc>
      break;
    80005eda:	b719                	j	80005de0 <printf+0x9a>
      consputc('%');
    80005edc:	8556                	mv	a0,s5
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	b5a080e7          	jalr	-1190(ra) # 80005a38 <consputc>
      consputc(c);
    80005ee6:	8526                	mv	a0,s1
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	b50080e7          	jalr	-1200(ra) # 80005a38 <consputc>
      break;
    80005ef0:	bdc5                	j	80005de0 <printf+0x9a>
  if(locking)
    80005ef2:	020d9163          	bnez	s11,80005f14 <printf+0x1ce>
}
    80005ef6:	70e6                	ld	ra,120(sp)
    80005ef8:	7446                	ld	s0,112(sp)
    80005efa:	74a6                	ld	s1,104(sp)
    80005efc:	7906                	ld	s2,96(sp)
    80005efe:	69e6                	ld	s3,88(sp)
    80005f00:	6a46                	ld	s4,80(sp)
    80005f02:	6aa6                	ld	s5,72(sp)
    80005f04:	6b06                	ld	s6,64(sp)
    80005f06:	7be2                	ld	s7,56(sp)
    80005f08:	7c42                	ld	s8,48(sp)
    80005f0a:	7ca2                	ld	s9,40(sp)
    80005f0c:	7d02                	ld	s10,32(sp)
    80005f0e:	6de2                	ld	s11,24(sp)
    80005f10:	6129                	addi	sp,sp,192
    80005f12:	8082                	ret
    release(&pr.lock);
    80005f14:	00021517          	auipc	a0,0x21
    80005f18:	e1450513          	addi	a0,a0,-492 # 80026d28 <pr>
    80005f1c:	00000097          	auipc	ra,0x0
    80005f20:	418080e7          	jalr	1048(ra) # 80006334 <release>
}
    80005f24:	bfc9                	j	80005ef6 <printf+0x1b0>

0000000080005f26 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f26:	1101                	addi	sp,sp,-32
    80005f28:	ec06                	sd	ra,24(sp)
    80005f2a:	e822                	sd	s0,16(sp)
    80005f2c:	e426                	sd	s1,8(sp)
    80005f2e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f30:	00021497          	auipc	s1,0x21
    80005f34:	df848493          	addi	s1,s1,-520 # 80026d28 <pr>
    80005f38:	00003597          	auipc	a1,0x3
    80005f3c:	8d058593          	addi	a1,a1,-1840 # 80008808 <syscalls+0x438>
    80005f40:	8526                	mv	a0,s1
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	2ae080e7          	jalr	686(ra) # 800061f0 <initlock>
  pr.locking = 1;
    80005f4a:	4785                	li	a5,1
    80005f4c:	cc9c                	sw	a5,24(s1)
}
    80005f4e:	60e2                	ld	ra,24(sp)
    80005f50:	6442                	ld	s0,16(sp)
    80005f52:	64a2                	ld	s1,8(sp)
    80005f54:	6105                	addi	sp,sp,32
    80005f56:	8082                	ret

0000000080005f58 <backtrace>:

void backtrace()
{
    80005f58:	7179                	addi	sp,sp,-48
    80005f5a:	f406                	sd	ra,40(sp)
    80005f5c:	f022                	sd	s0,32(sp)
    80005f5e:	ec26                	sd	s1,24(sp)
    80005f60:	e84a                	sd	s2,16(sp)
    80005f62:	e44e                	sd	s3,8(sp)
    80005f64:	1800                	addi	s0,sp,48

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x));
    80005f66:	84a2                	mv	s1,s0
  uint64 now_fp = r_fp();
  uint64 fram_up = PGROUNDUP(now_fp);
    80005f68:	6905                	lui	s2,0x1
    80005f6a:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005f6c:	9926                	add	s2,s2,s1
    80005f6e:	77fd                	lui	a5,0xfffff
    80005f70:	00f97933          	and	s2,s2,a5
  // printf("fp = %p\n", now_fp);
  while (now_fp != fram_up)
    80005f74:	02990163          	beq	s2,s1,80005f96 <backtrace+0x3e>
  {
    /* code */
    printf("ra = %p\n", *(uint64*)(now_fp-8));
    80005f78:	00003997          	auipc	s3,0x3
    80005f7c:	89898993          	addi	s3,s3,-1896 # 80008810 <syscalls+0x440>
    80005f80:	ff84b583          	ld	a1,-8(s1)
    80005f84:	854e                	mv	a0,s3
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	dc0080e7          	jalr	-576(ra) # 80005d46 <printf>
    //printf("fp = %p\n", *(uint64*)(now_fp-16));

    now_fp = *(uint64*)(now_fp-16);
    80005f8e:	ff04b483          	ld	s1,-16(s1)
  while (now_fp != fram_up)
    80005f92:	fe9917e3          	bne	s2,s1,80005f80 <backtrace+0x28>
  }
  
}
    80005f96:	70a2                	ld	ra,40(sp)
    80005f98:	7402                	ld	s0,32(sp)
    80005f9a:	64e2                	ld	s1,24(sp)
    80005f9c:	6942                	ld	s2,16(sp)
    80005f9e:	69a2                	ld	s3,8(sp)
    80005fa0:	6145                	addi	sp,sp,48
    80005fa2:	8082                	ret

0000000080005fa4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fa4:	1141                	addi	sp,sp,-16
    80005fa6:	e406                	sd	ra,8(sp)
    80005fa8:	e022                	sd	s0,0(sp)
    80005faa:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fac:	100007b7          	lui	a5,0x10000
    80005fb0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fb4:	f8000713          	li	a4,-128
    80005fb8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fbc:	470d                	li	a4,3
    80005fbe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fc2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fc6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fca:	469d                	li	a3,7
    80005fcc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fd0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fd4:	00003597          	auipc	a1,0x3
    80005fd8:	86458593          	addi	a1,a1,-1948 # 80008838 <digits+0x18>
    80005fdc:	00021517          	auipc	a0,0x21
    80005fe0:	d6c50513          	addi	a0,a0,-660 # 80026d48 <uart_tx_lock>
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	20c080e7          	jalr	524(ra) # 800061f0 <initlock>
}
    80005fec:	60a2                	ld	ra,8(sp)
    80005fee:	6402                	ld	s0,0(sp)
    80005ff0:	0141                	addi	sp,sp,16
    80005ff2:	8082                	ret

0000000080005ff4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ff4:	1101                	addi	sp,sp,-32
    80005ff6:	ec06                	sd	ra,24(sp)
    80005ff8:	e822                	sd	s0,16(sp)
    80005ffa:	e426                	sd	s1,8(sp)
    80005ffc:	1000                	addi	s0,sp,32
    80005ffe:	84aa                	mv	s1,a0
  push_off();
    80006000:	00000097          	auipc	ra,0x0
    80006004:	234080e7          	jalr	564(ra) # 80006234 <push_off>

  if(panicked){
    80006008:	00003797          	auipc	a5,0x3
    8000600c:	8f47a783          	lw	a5,-1804(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006010:	10000737          	lui	a4,0x10000
  if(panicked){
    80006014:	c391                	beqz	a5,80006018 <uartputc_sync+0x24>
    for(;;)
    80006016:	a001                	j	80006016 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006018:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000601c:	0207f793          	andi	a5,a5,32
    80006020:	dfe5                	beqz	a5,80006018 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006022:	0ff4f513          	zext.b	a0,s1
    80006026:	100007b7          	lui	a5,0x10000
    8000602a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	2a6080e7          	jalr	678(ra) # 800062d4 <pop_off>
}
    80006036:	60e2                	ld	ra,24(sp)
    80006038:	6442                	ld	s0,16(sp)
    8000603a:	64a2                	ld	s1,8(sp)
    8000603c:	6105                	addi	sp,sp,32
    8000603e:	8082                	ret

0000000080006040 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006040:	00003797          	auipc	a5,0x3
    80006044:	8c07b783          	ld	a5,-1856(a5) # 80008900 <uart_tx_r>
    80006048:	00003717          	auipc	a4,0x3
    8000604c:	8c073703          	ld	a4,-1856(a4) # 80008908 <uart_tx_w>
    80006050:	06f70a63          	beq	a4,a5,800060c4 <uartstart+0x84>
{
    80006054:	7139                	addi	sp,sp,-64
    80006056:	fc06                	sd	ra,56(sp)
    80006058:	f822                	sd	s0,48(sp)
    8000605a:	f426                	sd	s1,40(sp)
    8000605c:	f04a                	sd	s2,32(sp)
    8000605e:	ec4e                	sd	s3,24(sp)
    80006060:	e852                	sd	s4,16(sp)
    80006062:	e456                	sd	s5,8(sp)
    80006064:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006066:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000606a:	00021a17          	auipc	s4,0x21
    8000606e:	cdea0a13          	addi	s4,s4,-802 # 80026d48 <uart_tx_lock>
    uart_tx_r += 1;
    80006072:	00003497          	auipc	s1,0x3
    80006076:	88e48493          	addi	s1,s1,-1906 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000607a:	00003997          	auipc	s3,0x3
    8000607e:	88e98993          	addi	s3,s3,-1906 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006082:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006086:	02077713          	andi	a4,a4,32
    8000608a:	c705                	beqz	a4,800060b2 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000608c:	01f7f713          	andi	a4,a5,31
    80006090:	9752                	add	a4,a4,s4
    80006092:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006096:	0785                	addi	a5,a5,1
    80006098:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000609a:	8526                	mv	a0,s1
    8000609c:	ffffb097          	auipc	ra,0xffffb
    800060a0:	4f6080e7          	jalr	1270(ra) # 80001592 <wakeup>
    
    WriteReg(THR, c);
    800060a4:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060a8:	609c                	ld	a5,0(s1)
    800060aa:	0009b703          	ld	a4,0(s3)
    800060ae:	fcf71ae3          	bne	a4,a5,80006082 <uartstart+0x42>
  }
}
    800060b2:	70e2                	ld	ra,56(sp)
    800060b4:	7442                	ld	s0,48(sp)
    800060b6:	74a2                	ld	s1,40(sp)
    800060b8:	7902                	ld	s2,32(sp)
    800060ba:	69e2                	ld	s3,24(sp)
    800060bc:	6a42                	ld	s4,16(sp)
    800060be:	6aa2                	ld	s5,8(sp)
    800060c0:	6121                	addi	sp,sp,64
    800060c2:	8082                	ret
    800060c4:	8082                	ret

00000000800060c6 <uartputc>:
{
    800060c6:	7179                	addi	sp,sp,-48
    800060c8:	f406                	sd	ra,40(sp)
    800060ca:	f022                	sd	s0,32(sp)
    800060cc:	ec26                	sd	s1,24(sp)
    800060ce:	e84a                	sd	s2,16(sp)
    800060d0:	e44e                	sd	s3,8(sp)
    800060d2:	e052                	sd	s4,0(sp)
    800060d4:	1800                	addi	s0,sp,48
    800060d6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060d8:	00021517          	auipc	a0,0x21
    800060dc:	c7050513          	addi	a0,a0,-912 # 80026d48 <uart_tx_lock>
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	1a0080e7          	jalr	416(ra) # 80006280 <acquire>
  if(panicked){
    800060e8:	00003797          	auipc	a5,0x3
    800060ec:	8147a783          	lw	a5,-2028(a5) # 800088fc <panicked>
    800060f0:	e7c9                	bnez	a5,8000617a <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060f2:	00003717          	auipc	a4,0x3
    800060f6:	81673703          	ld	a4,-2026(a4) # 80008908 <uart_tx_w>
    800060fa:	00003797          	auipc	a5,0x3
    800060fe:	8067b783          	ld	a5,-2042(a5) # 80008900 <uart_tx_r>
    80006102:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006106:	00021997          	auipc	s3,0x21
    8000610a:	c4298993          	addi	s3,s3,-958 # 80026d48 <uart_tx_lock>
    8000610e:	00002497          	auipc	s1,0x2
    80006112:	7f248493          	addi	s1,s1,2034 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006116:	00002917          	auipc	s2,0x2
    8000611a:	7f290913          	addi	s2,s2,2034 # 80008908 <uart_tx_w>
    8000611e:	00e79f63          	bne	a5,a4,8000613c <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006122:	85ce                	mv	a1,s3
    80006124:	8526                	mv	a0,s1
    80006126:	ffffb097          	auipc	ra,0xffffb
    8000612a:	408080e7          	jalr	1032(ra) # 8000152e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612e:	00093703          	ld	a4,0(s2)
    80006132:	609c                	ld	a5,0(s1)
    80006134:	02078793          	addi	a5,a5,32
    80006138:	fee785e3          	beq	a5,a4,80006122 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000613c:	00021497          	auipc	s1,0x21
    80006140:	c0c48493          	addi	s1,s1,-1012 # 80026d48 <uart_tx_lock>
    80006144:	01f77793          	andi	a5,a4,31
    80006148:	97a6                	add	a5,a5,s1
    8000614a:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000614e:	0705                	addi	a4,a4,1
    80006150:	00002797          	auipc	a5,0x2
    80006154:	7ae7bc23          	sd	a4,1976(a5) # 80008908 <uart_tx_w>
  uartstart();
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	ee8080e7          	jalr	-280(ra) # 80006040 <uartstart>
  release(&uart_tx_lock);
    80006160:	8526                	mv	a0,s1
    80006162:	00000097          	auipc	ra,0x0
    80006166:	1d2080e7          	jalr	466(ra) # 80006334 <release>
}
    8000616a:	70a2                	ld	ra,40(sp)
    8000616c:	7402                	ld	s0,32(sp)
    8000616e:	64e2                	ld	s1,24(sp)
    80006170:	6942                	ld	s2,16(sp)
    80006172:	69a2                	ld	s3,8(sp)
    80006174:	6a02                	ld	s4,0(sp)
    80006176:	6145                	addi	sp,sp,48
    80006178:	8082                	ret
    for(;;)
    8000617a:	a001                	j	8000617a <uartputc+0xb4>

000000008000617c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000617c:	1141                	addi	sp,sp,-16
    8000617e:	e422                	sd	s0,8(sp)
    80006180:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006182:	100007b7          	lui	a5,0x10000
    80006186:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000618a:	8b85                	andi	a5,a5,1
    8000618c:	cb81                	beqz	a5,8000619c <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000618e:	100007b7          	lui	a5,0x10000
    80006192:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006196:	6422                	ld	s0,8(sp)
    80006198:	0141                	addi	sp,sp,16
    8000619a:	8082                	ret
    return -1;
    8000619c:	557d                	li	a0,-1
    8000619e:	bfe5                	j	80006196 <uartgetc+0x1a>

00000000800061a0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061a0:	1101                	addi	sp,sp,-32
    800061a2:	ec06                	sd	ra,24(sp)
    800061a4:	e822                	sd	s0,16(sp)
    800061a6:	e426                	sd	s1,8(sp)
    800061a8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061aa:	54fd                	li	s1,-1
    800061ac:	a029                	j	800061b6 <uartintr+0x16>
      break;
    consoleintr(c);
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	8cc080e7          	jalr	-1844(ra) # 80005a7a <consoleintr>
    int c = uartgetc();
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	fc6080e7          	jalr	-58(ra) # 8000617c <uartgetc>
    if(c == -1)
    800061be:	fe9518e3          	bne	a0,s1,800061ae <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061c2:	00021497          	auipc	s1,0x21
    800061c6:	b8648493          	addi	s1,s1,-1146 # 80026d48 <uart_tx_lock>
    800061ca:	8526                	mv	a0,s1
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	0b4080e7          	jalr	180(ra) # 80006280 <acquire>
  uartstart();
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	e6c080e7          	jalr	-404(ra) # 80006040 <uartstart>
  release(&uart_tx_lock);
    800061dc:	8526                	mv	a0,s1
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	156080e7          	jalr	342(ra) # 80006334 <release>
}
    800061e6:	60e2                	ld	ra,24(sp)
    800061e8:	6442                	ld	s0,16(sp)
    800061ea:	64a2                	ld	s1,8(sp)
    800061ec:	6105                	addi	sp,sp,32
    800061ee:	8082                	ret

00000000800061f0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061f0:	1141                	addi	sp,sp,-16
    800061f2:	e422                	sd	s0,8(sp)
    800061f4:	0800                	addi	s0,sp,16
  lk->name = name;
    800061f6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061f8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061fc:	00053823          	sd	zero,16(a0)
}
    80006200:	6422                	ld	s0,8(sp)
    80006202:	0141                	addi	sp,sp,16
    80006204:	8082                	ret

0000000080006206 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006206:	411c                	lw	a5,0(a0)
    80006208:	e399                	bnez	a5,8000620e <holding+0x8>
    8000620a:	4501                	li	a0,0
  return r;
}
    8000620c:	8082                	ret
{
    8000620e:	1101                	addi	sp,sp,-32
    80006210:	ec06                	sd	ra,24(sp)
    80006212:	e822                	sd	s0,16(sp)
    80006214:	e426                	sd	s1,8(sp)
    80006216:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006218:	6904                	ld	s1,16(a0)
    8000621a:	ffffb097          	auipc	ra,0xffffb
    8000621e:	c1c080e7          	jalr	-996(ra) # 80000e36 <mycpu>
    80006222:	40a48533          	sub	a0,s1,a0
    80006226:	00153513          	seqz	a0,a0
}
    8000622a:	60e2                	ld	ra,24(sp)
    8000622c:	6442                	ld	s0,16(sp)
    8000622e:	64a2                	ld	s1,8(sp)
    80006230:	6105                	addi	sp,sp,32
    80006232:	8082                	ret

0000000080006234 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006234:	1101                	addi	sp,sp,-32
    80006236:	ec06                	sd	ra,24(sp)
    80006238:	e822                	sd	s0,16(sp)
    8000623a:	e426                	sd	s1,8(sp)
    8000623c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623e:	100024f3          	csrr	s1,sstatus
    80006242:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006246:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006248:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000624c:	ffffb097          	auipc	ra,0xffffb
    80006250:	bea080e7          	jalr	-1046(ra) # 80000e36 <mycpu>
    80006254:	5d3c                	lw	a5,120(a0)
    80006256:	cf89                	beqz	a5,80006270 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006258:	ffffb097          	auipc	ra,0xffffb
    8000625c:	bde080e7          	jalr	-1058(ra) # 80000e36 <mycpu>
    80006260:	5d3c                	lw	a5,120(a0)
    80006262:	2785                	addiw	a5,a5,1
    80006264:	dd3c                	sw	a5,120(a0)
}
    80006266:	60e2                	ld	ra,24(sp)
    80006268:	6442                	ld	s0,16(sp)
    8000626a:	64a2                	ld	s1,8(sp)
    8000626c:	6105                	addi	sp,sp,32
    8000626e:	8082                	ret
    mycpu()->intena = old;
    80006270:	ffffb097          	auipc	ra,0xffffb
    80006274:	bc6080e7          	jalr	-1082(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006278:	8085                	srli	s1,s1,0x1
    8000627a:	8885                	andi	s1,s1,1
    8000627c:	dd64                	sw	s1,124(a0)
    8000627e:	bfe9                	j	80006258 <push_off+0x24>

0000000080006280 <acquire>:
{
    80006280:	1101                	addi	sp,sp,-32
    80006282:	ec06                	sd	ra,24(sp)
    80006284:	e822                	sd	s0,16(sp)
    80006286:	e426                	sd	s1,8(sp)
    80006288:	1000                	addi	s0,sp,32
    8000628a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	fa8080e7          	jalr	-88(ra) # 80006234 <push_off>
  if(holding(lk))
    80006294:	8526                	mv	a0,s1
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	f70080e7          	jalr	-144(ra) # 80006206 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000629e:	4705                	li	a4,1
  if(holding(lk))
    800062a0:	e115                	bnez	a0,800062c4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062a2:	87ba                	mv	a5,a4
    800062a4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062a8:	2781                	sext.w	a5,a5
    800062aa:	ffe5                	bnez	a5,800062a2 <acquire+0x22>
  __sync_synchronize();
    800062ac:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062b0:	ffffb097          	auipc	ra,0xffffb
    800062b4:	b86080e7          	jalr	-1146(ra) # 80000e36 <mycpu>
    800062b8:	e888                	sd	a0,16(s1)
}
    800062ba:	60e2                	ld	ra,24(sp)
    800062bc:	6442                	ld	s0,16(sp)
    800062be:	64a2                	ld	s1,8(sp)
    800062c0:	6105                	addi	sp,sp,32
    800062c2:	8082                	ret
    panic("acquire");
    800062c4:	00002517          	auipc	a0,0x2
    800062c8:	57c50513          	addi	a0,a0,1404 # 80008840 <digits+0x20>
    800062cc:	00000097          	auipc	ra,0x0
    800062d0:	a30080e7          	jalr	-1488(ra) # 80005cfc <panic>

00000000800062d4 <pop_off>:

void
pop_off(void)
{
    800062d4:	1141                	addi	sp,sp,-16
    800062d6:	e406                	sd	ra,8(sp)
    800062d8:	e022                	sd	s0,0(sp)
    800062da:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	b5a080e7          	jalr	-1190(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062e4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062e8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062ea:	e78d                	bnez	a5,80006314 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062ec:	5d3c                	lw	a5,120(a0)
    800062ee:	02f05b63          	blez	a5,80006324 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062f2:	37fd                	addiw	a5,a5,-1
    800062f4:	0007871b          	sext.w	a4,a5
    800062f8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062fa:	eb09                	bnez	a4,8000630c <pop_off+0x38>
    800062fc:	5d7c                	lw	a5,124(a0)
    800062fe:	c799                	beqz	a5,8000630c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006300:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006304:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006308:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000630c:	60a2                	ld	ra,8(sp)
    8000630e:	6402                	ld	s0,0(sp)
    80006310:	0141                	addi	sp,sp,16
    80006312:	8082                	ret
    panic("pop_off - interruptible");
    80006314:	00002517          	auipc	a0,0x2
    80006318:	53450513          	addi	a0,a0,1332 # 80008848 <digits+0x28>
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	9e0080e7          	jalr	-1568(ra) # 80005cfc <panic>
    panic("pop_off");
    80006324:	00002517          	auipc	a0,0x2
    80006328:	53c50513          	addi	a0,a0,1340 # 80008860 <digits+0x40>
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	9d0080e7          	jalr	-1584(ra) # 80005cfc <panic>

0000000080006334 <release>:
{
    80006334:	1101                	addi	sp,sp,-32
    80006336:	ec06                	sd	ra,24(sp)
    80006338:	e822                	sd	s0,16(sp)
    8000633a:	e426                	sd	s1,8(sp)
    8000633c:	1000                	addi	s0,sp,32
    8000633e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006340:	00000097          	auipc	ra,0x0
    80006344:	ec6080e7          	jalr	-314(ra) # 80006206 <holding>
    80006348:	c115                	beqz	a0,8000636c <release+0x38>
  lk->cpu = 0;
    8000634a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000634e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006352:	0f50000f          	fence	iorw,ow
    80006356:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	f7a080e7          	jalr	-134(ra) # 800062d4 <pop_off>
}
    80006362:	60e2                	ld	ra,24(sp)
    80006364:	6442                	ld	s0,16(sp)
    80006366:	64a2                	ld	s1,8(sp)
    80006368:	6105                	addi	sp,sp,32
    8000636a:	8082                	ret
    panic("release");
    8000636c:	00002517          	auipc	a0,0x2
    80006370:	4fc50513          	addi	a0,a0,1276 # 80008868 <digits+0x48>
    80006374:	00000097          	auipc	ra,0x0
    80006378:	988080e7          	jalr	-1656(ra) # 80005cfc <panic>
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
