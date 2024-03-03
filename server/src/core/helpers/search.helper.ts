export function getWhereByCondition(parentCategoryId: number) {
  if (parentCategoryId === -1) {
    return {};
  } else {
    return { parentCategoryId };
  }
}
